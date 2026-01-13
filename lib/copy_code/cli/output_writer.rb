# frozen_string_literal: true

# This file defines the CopyCode::CLI::OutputWriter class, which is responsible
# for outputting formatted code content to either:
#   - The clipboard (using macOS `pbcopy`)
#   - A text file named `code_output.txt`
#
# Output method is selected via CLI flag `-p txt|pbcopy`.

module CopyCode
  module CLI
    # OutputWriter handles writing the final formatted code string
    # to the destination selected by the user (`pbcopy` or `txt`).
    #
    # If `txt` is specified, the content is saved to `code_output.txt`.
    # If no method or `pbcopy` is specified, the content is copied to the clipboard
    # using macOS `pbcopy` via `IO.popen`.
    class OutputWriter
      # Writes the given content to the selected output method.
      #
      # @param content [String] the fully formatted output content
      # @param method [String] the output method ("txt" or "pbcopy")
      # @param output_path [String, nil] optional path for text file output
      # @return [void]
      def self.write(content, method, output_path: nil)
        normalized_method = method.to_s.strip.downcase
        case normalized_method
        when "txt"
          path = output_path || "code_output.txt"
          File.write(path, content)
          puts "✅ Saved to #{path}"
        else
          IO.popen("pbcopy", "w") { |io| io.write(content) }
          puts "✅ Copied to clipboard"
        end
      end
    end
  end
end
