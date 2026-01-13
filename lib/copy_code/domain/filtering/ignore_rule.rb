# frozen_string_literal: true

module CopyCode
  module Domain
    module Filtering
      # IgnoreRule represents a single gitignore-style rule.
      class IgnoreRule
        MATCH_OPTIONS = File::FNM_PATHNAME | File::FNM_EXTGLOB

        def self.from(raw_pattern)
          pattern = raw_pattern.to_s.strip
          return if pattern.empty?

          new(pattern)
        end

        def initialize(pattern)
          @negated = pattern.start_with?("!")
          pattern = pattern[1..] if @negated

          @directory_only = pattern.end_with?("/")
          pattern = pattern.chomp("/")

          @anchored = pattern.start_with?("/")
          pattern = pattern.sub(%r{\A/+}, "")

          @pattern = pattern
          @globs = compile_globs(pattern)
        end

        # Applies the rule to the provided path, returning the updated ignored state.
        #
        # @param path [String] relative path from the project root
        # @param ignored [Boolean] current ignored state
        # @return [Boolean] new ignored state
        def apply(path, ignored)
          return ignored unless matches?(path)

          @negated ? false : true
        end

        private

        def matches?(path)
          return false if @globs.empty?

          return directory_match?(path) if @directory_only

          @globs.any? { |glob| File.fnmatch?(glob, path, MATCH_OPTIONS) }
        end

        def compile_globs(pattern)
          return [] if pattern.nil? || pattern.empty?

          base = if @anchored
            pattern
          else
            compile_unanchored(pattern)
          end

          glob_variants(base)
        end

        def compile_unanchored(pattern)
          pattern.start_with?("**/") ? pattern : "**/#{pattern}"
        end

        def glob_variants(base)
          sanitized = base.gsub(%r{//+}, "/")

          if @directory_only
            [
              sanitized,
              "#{sanitized}/**"
            ]
          elsif base.include?("/")
            [sanitized]
          else
            [
              sanitized,
              "#{sanitized}/**"
            ]
          end
        end

        def directory_match?(path)
          return false if @pattern.nil? || @pattern.empty?

          if glob_pattern?(@pattern)
            return directory_glob_match?(path, @pattern)
          end

          if @anchored
            return path == @pattern || path.start_with?("#{@pattern}/")
          end

          path.match?(%r{(^|/)#{Regexp.escape(@pattern)}(/|$)})
        end

        def directory_glob_match?(path, pattern)
          sanitized_pattern = strip_leading_double_star(pattern)
          regex = glob_to_regex(sanitized_pattern)
          if @anchored
            if pattern.start_with?("**/")
              path.match?(%r{\A(?:.*/)?#{regex}(?:/|$)})
            else
              path.match?(%r{\A#{regex}(?:/|$)})
            end
          else
            path.match?(%r{(^|/)#{regex}(?:/|$)})
          end
        end

        def glob_to_regex(pattern)
          regex = +""
          index = 0

          while index < pattern.length
            char = pattern[index]
            next_char = pattern[index + 1]

            if char == "*" && next_char == "*"
              regex << ".*"
              index += 2
              next
            end

            case char
            when "*"
              regex << "[^/]*"
            when "?"
              regex << "[^/]"
            when "["
              index = append_character_class(regex, pattern, index)
            when "{"
              index = append_brace_group(regex, pattern, index)
            else
              regex << Regexp.escape(char)
            end

            index += 1
          end

          regex
        end

        def append_character_class(regex, pattern, start_index)
          closing = pattern.index("]", start_index + 1)
          return append_literal(regex, pattern[start_index], start_index) unless closing

          content = pattern[(start_index + 1)...closing]
          if content.start_with?("!")
            content = "^" + Regexp.escape(content[1..])
          else
            content = Regexp.escape(content)
          end

          regex << "[#{content}]"
          closing
        end

        def append_brace_group(regex, pattern, start_index)
          closing = pattern.index("}", start_index + 1)
          return append_literal(regex, pattern[start_index], start_index) unless closing

          content = pattern[(start_index + 1)...closing]
          parts = content.split(",").map { |part| Regexp.escape(part) }
          regex << "(?:#{parts.join("|")})"
          closing
        end

        def append_literal(regex, char, index)
          regex << Regexp.escape(char)
          index
        end

        def glob_pattern?(value)
          value.match?(/[?*\[\{]/)
        end

        def strip_leading_double_star(pattern)
          pattern.start_with?("**/") ? pattern.delete_prefix("**/") : pattern
        end
      end
    end
  end
end
