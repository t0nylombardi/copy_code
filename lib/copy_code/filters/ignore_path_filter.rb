# frozen_string_literal: true

require_relative "../domain/filtering"

module CopyCode
  module Filters
    # Filters files by gitignore-style path rules.
    class IgnorePathFilter
      # @param ignore_patterns [Array<String>] gitignore-like patterns
      # @param root [String] directory the patterns are relative to
      def initialize(ignore_patterns, root:)
        @resolver = Domain::Filtering::RelativePathResolver.new(root: root)
        @rules = Domain::Filtering::IgnoreRuleSet.new(ignore_patterns)
      end

      # @param file [String]
      # @return [Boolean] whether the file should be excluded
      def exclude?(file)
        return false if @rules.empty?

        relative = @resolver.call(file)
        @rules.ignored?(relative)
      end
    end
  end
end
