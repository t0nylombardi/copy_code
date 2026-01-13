# frozen_string_literal: true

require "pathname"

# copy_code/lib/copy_code/cli/runner.rb
#
# This file defines the CopyCode::CLI::Runner class, which is the core orchestrator
# for the command-line execution of the copy_code tool.
#
# The Runner is responsible for:
# - Parsing CLI arguments
# - Loading ignore patterns
# - Constructing file filters
# - Discovering and formatting files
# - Writing the result to either clipboard or a text file
#
# It separates the CLI runtime flow from the CLI namespace (CopyCode::CLI),
# following SOLID and DDD principles.

module CopyCode
  module CLI
    # Runner executes the core command flow of the CopyCode CLI.
    #
    # It acts as a controller between CLI argument parsing,
    # file discovery, formatting, and output.
    class Runner
      # @param argv [Array<String>] the raw arguments passed from the command line
      def initialize(argv)
        @argv = argv
      end

      def self.run(argv)
        new(argv).execute
      end

      # Executes the complete CLI flow: parse → filter → format → output.
      #
      # @return [void]
      def execute
        OutputWriter.write(result, options[:output], output_path: output_path)
      end

      private

      # Constructs all filters to apply during file discovery.
      #
      # @return [Array<#exclude?>] array of filter objects
      def filters
        @filters ||= begin
          ignore_config = IgnoreLoader.load(options[:targets].first)
          [
            Filters::FileExtensionFilter.new(options[:extensions]),
            Filters::IgnorePathFilter.new(
              ignore_config.patterns,
              root: ignore_config.base_dir
            )
          ]
        end
      end

      # Creates the core file discovery/formatting engine.
      #
      # @return [CopyCode::Core]
      def core
        @core ||= Core.new(
          targets: options[:targets],
          filters: filters
        )
      end

      # Retrieves the list of matching files from the core engine.
      #
      # @return [Array<String>] list of file paths
      def files
        @files ||= core.gather_files
      end

      # Formats the gathered files into a single output string.
      #
      # @return [String] formatted code content
      def result
        @result ||= core.format(files)
      end

      # Parses the command-line arguments using the CLI parser.
      #
      # @return [Hash] parsed options hash
      def options
        @options ||= Parser.new(@argv).parse
      end

      # Determines where to write the text output, if requested.
      #
      # @return [String, nil] absolute output path or nil when not writing a file
      def output_path
        return nil unless options[:output].to_s.strip.casecmp("txt").zero?

        explicit_path = options[:output_path]
        target = options[:targets].first
        base_dir = File.directory?(target) ? target : Dir.pwd
        return File.join(base_dir, "code_output.txt") if explicit_path.nil? || explicit_path.strip.empty?

        resolved_path = File.expand_path(explicit_path, base_dir)
        return File.join(resolved_path, "code_output.txt") if directory_like?(explicit_path, resolved_path)

        resolved_path
      end

      def directory_like?(explicit_path, resolved_path)
        return true if explicit_path.end_with?(File::SEPARATOR)
        return true if [".", ".."].include?(explicit_path)
        return true if File.directory?(resolved_path)

        false
      end
    end
  end
end
