# frozen_string_literal: true

module CopyCode
  module Domain
    module Filtering
      # PatternWhitelist encapsulates glob-based inclusion rules for filenames.
      class PatternWhitelist
        MATCH_OPTIONS = File::FNM_EXTGLOB | File::FNM_PATHNAME

        def initialize(patterns)
          @patterns = build_patterns(patterns)
        end

        # @param file [String]
        # @return [Boolean] whether the file should be included by the whitelist
        def include?(file)
          return true if @patterns.empty?

          basename = File.basename(file)
          @patterns.any? { |pattern| File.fnmatch?(pattern, basename, MATCH_OPTIONS) }
        end

        private

        def build_patterns(patterns)
          Array(patterns).filter_map do |pattern|
            normalized_pattern(pattern)
          end
        end

        def normalized_pattern(raw)
          value = raw.to_s.strip
          return if value.empty?

          return value if glob_pattern?(value)

          normalized = value.sub(/\A\./, "")
          "*.#{normalized}"
        end

        def glob_pattern?(value)
          value.match?(/[?*\[\{]/)
        end
      end
    end
  end
end
