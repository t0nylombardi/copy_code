# frozen_string_literal: true

require_relative "../domain/filtering"

module CopyCode
  module Filters
    # Filters files by allowed extension or glob pattern, delegating to the domain whitelist.
    class FileExtensionFilter
      # @param extensions [Array<String>] file extensions without dot (e.g., "rb", "js")
      def initialize(extensions)
        @whitelist = Domain::Filtering::PatternWhitelist.new(extensions)
      end

      # @param file [String]
      # @return [Boolean] whether the file should be excluded
      def exclude?(file)
        !@whitelist.include?(file)
      end
    end
  end
end
