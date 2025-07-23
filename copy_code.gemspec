# frozen_string_literal: true

require_relative "lib/copy_code/version"

Gem::Specification.new do |spec|
  spec.name = "copy_code"
  spec.version = CopyCode::VERSION
  spec.authors = ["t0nylombardi"]
  spec.email = ["your@email.com"]

  spec.summary = "CLI tool to copy code from a directory"
  spec.description = "CLI tool to find and copy code files from a project, with ignore rules and output options"

  spec.license = "MIT"
  spec.homepage = "https://github.com/t0nylombardi/copy_code"

  spec.required_ruby_version = ">= 3.0"

  spec.bindir = "bin"
  spec.executables = ["copy_code"]
  spec.require_paths = ["lib"]
  spec.files = Dir["lib/**/*.rb"] + ["bin/copy_code"]
end
