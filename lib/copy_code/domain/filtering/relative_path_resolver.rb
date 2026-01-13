# frozen_string_literal: true

require "pathname"

module CopyCode
  module Domain
    module Filtering
      # RelativePathResolver converts absolute file paths into paths relative to a root.
      class RelativePathResolver
        def initialize(root:)
          @root = Pathname.new(File.expand_path(root || Dir.pwd))
        end

        # @param file [String]
        # @return [String] the path relative to the configured root
        def call(file)
          file_path = Pathname.new(File.expand_path(file))
          relative = file_path.relative_path_from(@root).to_s
          return file_path.to_s if outside_root?(relative)

          relative
        rescue ArgumentError
          file_path.to_s
        end

        def outside_root?(relative)
          relative == ".." || relative.start_with?("..#{File::SEPARATOR}")
        end
      end
    end
  end
end
