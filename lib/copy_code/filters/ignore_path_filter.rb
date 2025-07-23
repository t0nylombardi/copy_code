# frozen_string_literal: true

module CopyCode
  module Filters
    # Filters files by path substrings (e.g., ".venv", "node_modules")
    class IgnorePathFilter
      # @param ignore_patterns [Array<String>] substrings to match in file paths
      def initialize(ignore_patterns)
        @patterns = ignore_patterns
      end

      # @param file [String]
      # @return [Boolean] whether the file should be excluded
      def exclude?(file)
        @patterns.any? { |pattern| file.include?("/#{pattern}/") }
      end
    end
  end
end
