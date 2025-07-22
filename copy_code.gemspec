# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "copy_code"
  spec.version = "0.1.0"
  spec.authors = ["t0nylombardi"]
  spec.summary = "CLI tool to copy code from a directory"
  spec.description = "CLI tool to find and copy code files from a project, with ignore rules and output options"
  spec.bindir = "bin"
  spec.files = Dir["lib/**/*.rb"] + ["bin/copy_code"]
  spec.executables = ["copy_code"]
  spec.require_paths = ["lib"]
end
