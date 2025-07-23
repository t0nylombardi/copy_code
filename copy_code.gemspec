# frozen_string_literal: true

require_relative "lib/copy_code/version"

Gem::Specification.new do |spec|
  spec.name = "copy_code"
  spec.version = CopyCode::VERSION
  spec.authors = ["t0nylombardi"]
  spec.email = ["alombardi.331@gmail.com"]

  spec.summary = "CLI tool to copy code from a directory"
  spec.description = "Find and copy code files from a project, with ignore rules and output options"
  spec.homepage = "https://github.com/t0nylombardi/copy_code"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md" # optional

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.each_line("\x0", chomp: true).reject do |f|
      f == gemspec ||
        f.start_with?(*%w[Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end

  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies (only if needed)
  # spec.add_dependency "thor"
end
