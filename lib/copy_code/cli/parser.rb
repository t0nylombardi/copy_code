# frozen_string_literal: true

require "optparse"

module CopyCode
  module CLI
    # Parser handles CLI argument parsing and validation for the CopyCode CLI tool.
    #
    # It processes flags like:
    # - `-e` to specify file extensions
    # - `-p` to control output format (clipboard or text file)
    # and any paths passed to the command.
    #
    # Usage:
    #   parser = CopyCode::CLI::Parser.new(ARGV)
    #   options = parser.parse
    #
    # Returns an options hash:
    # {
    #   extensions: ['rb', 'py'],
    #   output: 'txt',
    #   targets: ['/full/path/to/project']
    # }
    class Parser
      # @param argv [Array<String>] The raw arguments passed from the command line
      def initialize(argv)
        @argv = argv
        @options = {
          extensions: [],
          output: "pbcopy",
          targets: []
        }
      end

      # Parses the provided arguments and returns a validated options hash.
      #
      # @return [Hash] Parsed and validated options including :extensions, :output, and :targets
      def parse
        build_parser.parse!(@argv)
        assign_targets
        validate_targets
        @options
      end

      private

      # Builds the OptionParser instance that parses CLI flags.
      #
      # @return [OptionParser]
      def build_parser
        OptionParser.new do |opts|
          opts.banner = "Usage: copy_code [options] [paths]"
          opts.on("-eEXT", "--extensions=EXT", "Comma-separated list (e.g. rb,py,js)") do |ext|
            @options[:extensions] = parse_extensions(ext)
          end
          opts.on("-pOUT", "--print=OUT", "Output method: pbcopy (default) or txt") do |out|
            @options[:output] = out
          end
        end
      end

      # Parses the extensions string passed from the CLI flag.
      #
      # @param raw [String] Comma-separated list of extensions
      # @return [Array<String>] Cleaned list of extensions
      def parse_extensions(raw)
        raw.split(",").map(&:strip)
      end

      # Expands and assigns the target paths passed as positional args.
      #
      # @return [void]
      def assign_targets
        @options[:targets] = @argv unless @argv.empty?
        @options[:targets].map! { |t| File.expand_path(t) }
      end

      # Validates each target path and warns if any don't exist.
      #
      # @return [void]
      def validate_targets
        @options[:targets].each do |path|
          warn "[WARN] Target path does not exist: #{path}" unless Dir.exist?(path)
        end
      end
    end
  end
end
