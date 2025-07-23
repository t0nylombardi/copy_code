# frozen_string_literal: true

# copy_code/lib/copy_code/cli/ignore_loader.rb
#
# This file defines the CopyCode::CLI::IgnoreLoader class, which is responsible
# for loading ignore patterns from a `.copy_codeignore` file.
#
# It checks the first project target path passed to the CLI, and falls back
# to the user's `~/.ccignore` if not found.

module CopyCode
  module CLI
    # IgnoreLoader loads a list of path substrings from a `.ccignore` file.
    # It will attempt to read from the first provided target path.
    #
    # If no ignore file exists in that path, it will fall back to ~/.ccignore.
    class IgnoreLoader
      # @param ignore_patterns [Array<String>] substrings to match in file paths
      def initialize(ignore_patterns = [])
        @patterns = ignore_patterns || []
      end

      # Loads ignore patterns from a given target directory or fallback path.
      #
      # @param target_path [String] the root of the scanned project
      # @return [Array<String>] a list of path substrings to ignore
      def self.load(target_path)
        local_file = File.join(target_path, ".ccignore")
        fallback_file = File.expand_path("~/.ccignore")

        file = File.exist?(local_file) ? local_file : fallback_file
        return [] unless File.exist?(file)

        lines = File.readlines(file).map(&:strip)
        lines.reject!(&:empty?)
        lines || []
      end

      # @param file [String]
      # @return [Boolean] whether the file should be excluded
      def exclude?(file)
        @patterns.any? { |pattern| file.include?("/#{pattern}/") }
      end
    end
  end
end
