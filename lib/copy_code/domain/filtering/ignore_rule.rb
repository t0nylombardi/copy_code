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
            ["#{sanitized}/**"]
          elsif base.include?("/")
            [sanitized]
          else
            [
              sanitized,
              "#{sanitized}/**"
            ]
          end
        end
      end
    end
  end
end
