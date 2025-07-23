# frozen_string_literal: true

require_relative "copy_code/version"
require_relative "copy_code/cli"
require_relative "copy_code/core"

require_relative "copy_code/filters/file_extension_filter"
require_relative "copy_code/filters/ignore_path_filter"
require_relative "copy_code/cli/ignore_loader"
require_relative "copy_code/cli/output_writer"
require_relative "copy_code/cli/parser"

module CopyCode
  # maybe some top-level stuff here
end
