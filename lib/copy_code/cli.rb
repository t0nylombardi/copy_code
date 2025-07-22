# frozen_string_literal: true

require "optparse"
require "fileutils"

module CopyCode
  class CLI
    def self.run(argv)
      options = {
        extensions: [],
        output: "pbcopy",
        targets: []
      }

      OptionParser.new do |opts|
        opts.banner = "Usage: copy_code [options] [path(s)]"

        opts.on("-eEXT", "--extensions=EXT", "Comma-separated list (e.g. rb,js)") do |ext|
          options[:extensions] = ext.split(",").map(&:strip)
        end

        opts.on("-pOUT", "--print=OUT", "Output: pbcopy (default) or txt") do |out|
          options[:output] = out
        end
      end.parse!(argv)

      options[:targets] = argv unless argv.empty?

      ignore_file = File.exist?(".copy_codeignore") ? ".copy_codeignore" : File.expand_path("~/.copy_codeignore")
      ignore_paths = File.exist?(ignore_file) ? File.readlines(ignore_file).map(&:strip).reject!(&:empty?) : []

      core = Core.new(
        targets: options[:targets],
        extensions: options[:extensions],
        ignore_paths: ignore_paths
      )

      files = core.gather_files
      result = core.output(files)

      if options[:output] == "txt"
        File.write("code_output.txt", result)
        puts "✅ Saved to code_output.txt"
      else
        IO.popen("pbcopy", "w") { |io| io.write(result) }
        puts "✅ Copied to clipboard"
      end
    end
  end
end
