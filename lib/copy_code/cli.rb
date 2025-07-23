# frozen_string_literal: true

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
        OutputWriter.write(result, options[:output])
      end

      private

      # Constructs all filters to apply during file discovery.
      #
      # @return [Array<#exclude?>] array of filter objects
      def filters
        @filters ||= [
          Filters::FileExtensionFilter.new(options[:extensions]),
          Filters::IgnorePathFilter.new(IgnoreLoader.load(options[:targets].first))
        ]
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
    end
  end
end
