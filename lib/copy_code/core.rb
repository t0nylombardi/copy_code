# frozen_string_literal: true

module CopyCode
  class Core
    def initialize(targets:, extensions:, ignore_paths:)
      @targets = targets.empty? ? ["."] : targets
      @extensions = extensions.map { |e| ".#{e.gsub(/^\./, "")}" }
      @ignore_paths = ignore_paths
    end

    def gather_files
      files = []

      @targets.each do |target|
        Dir.glob("#{target}/**/*", File::FNM_DOTMATCH).each do |file|
          next unless File.file?(file)
          next if ignored?(file)
          next unless matches_extension?(file)

          files << file
        end
      end

      files
    end

    def output(files)
      files.map do |file|
        header = "=== #{file} ==="
        content = File.read(file)
        "#{header}\n#{content}\n"
      end.join("\n")
    end

    private

    def ignored?(file)
      @ignore_paths.any? { |pattern| file.include?("/#{pattern}/") }
    end

    def matches_extension?(file)
      return true if @extensions.empty?
      @extensions.any? { |ext| file.end_with?(ext) }
    end
  end
end
