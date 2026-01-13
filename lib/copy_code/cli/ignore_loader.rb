# frozen_string_literal: true

# copy_code/lib/copy_code/cli/ignore_loader.rb
#
# This file defines the CopyCode::CLI::IgnoreLoader class, which is responsible
# for loading ignore patterns from `.ccignore` or `.cc_ignore`.
#
# It checks the first project target path passed to the CLI, and falls back
# to the user's `~/.ccignore` or `~/.cc_ignore` if not found.

require_relative "../filters/ignore_path_filter"

module CopyCode
  module CLI
    # IgnoreLoader loads ignore patterns from a `.ccignore` file, falling back to
    # the user's `~/.ccignore`. The result includes the directory the patterns
    # should be evaluated relative to.
    class IgnoreLoader
      Result = Struct.new(:patterns, :base_dir, keyword_init: true)

      # @param ignore_patterns [Array<String>] substrings to match in file paths
      def initialize(ignore_patterns = [], base_dir: Dir.pwd)
        @patterns = ignore_patterns || []
        @base_dir = base_dir
      end

      # Loads ignore patterns from a given target directory or fallback path.
      #
      # @param target_path [String] the root of the scanned project
      # @return [Result] a result containing patterns and the base directory
      def self.load(target_path)
        target_path = File.expand_path(target_path)
        local_file = first_existing_file(target_path, [".ccignore", ".cc_ignore"])
        fallback_file = first_existing_file(File.expand_path("~"), [".ccignore", ".cc_ignore"])

        file = local_file || fallback_file
        base_dir = file ? File.dirname(file) : target_path
        patterns = []

        if file && File.exist?(file)
          patterns = File.readlines(file, chomp: true)
          patterns.map!(&:strip)
          patterns.reject!(&:empty?)
          patterns.reject! { |line| line.start_with?("#") }
        end

        Result.new(patterns: patterns, base_dir: base_dir)
      end

      # @param file [String]
      # @return [Boolean] whether the file should be excluded
      def exclude?(file)
        Filters::IgnorePathFilter.new(@patterns, root: @base_dir).exclude?(file)
      end

      # @param base_dir [String]
      # @param names [Array<String>]
      # @return [String, nil] the first existing file path
      def self.first_existing_file(base_dir, names)
        names.each do |name|
          path = File.join(base_dir, name)
          return path if File.exist?(path)
        end

        nil
      end
    end
  end
end
