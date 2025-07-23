# frozen_string_literal: true

module CopyCode
  module Filters
    # Filters files by allowed extension
    class FileExtensionFilter
      # @param extensions [Array<String>] file extensions without dot (e.g., "rb", "js")
      def initialize(extensions)
        @extensions = extensions.map { |ext| ".#{ext.gsub(/^\./, "")}" }
      end

      # @param file [String]
      # @return [Boolean] whether the file should be excluded
      def exclude?(file)
        return false if @extensions.empty?

        !@extensions.any? { |ext| file.end_with?(ext) }
      end
    end
  end
end
