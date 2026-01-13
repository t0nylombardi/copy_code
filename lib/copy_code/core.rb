# frozen_string_literal: true

module CopyCode
  # Core file aggregator and formatter for the CopyCode domain
  class Core
    # @param targets [Array<String>] directories or files to scan
    # @param filters [Array<#exclude?>] list of objects responding to `exclude?(file)`
    def initialize(targets:, filters: [])
      @targets = targets.empty? ? ["."] : targets
      @filters = filters
    end

    # Gathers all matching files from the given targets.
    #
    # @return [Array<String>] list of absolute file paths
    def gather_files
      @targets.flat_map do |target|
        files_for_target(target).select { |file| include_file?(file) }
      end
    end

    # Formats the given files into output chunks with headers
    #
    # @param files [Array<String>] list of file paths
    # @return [String] formatted text
    def format(files)
      files.map do |file|
        header = "=== #{file} ==="
        content = File.read(file)
        "#{header}\n#{content}\n"
      end.join("\n")
    end

    private

    def files_for_target(target)
      return [target] if File.file?(target)
      return [] unless File.directory?(target)

      Dir.glob("#{target}/**/*", File::FNM_DOTMATCH).select { |file| File.file?(file) }
    end

    def include_file?(file)
      @filters.none? { |f| f.exclude?(file) }
    end
  end
end
