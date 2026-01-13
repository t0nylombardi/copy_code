# frozen_string_literal: true

require "spec_helper"

RSpec.describe "copy_code CLI", type: :aruba do
  it "writes the formatted output to a text file in the target directory" do
    write_file(
      "project/app/models/user.rb",
      "class User\nend\n"
    )

    run_command_and_stop("copy_code -e rb -p txt project")

    output = read("project/code_output.txt")
    expect(output.any? { |line| line.include?("app/models/user.rb") }).to be(true)
    expect(output.any? { |line| line.include?("class User") }).to be(true)
  end

  it "honors .ccignore rules for directory patterns" do
    write_file("project/.ccignore", "tmp/\n")
    write_file("project/tmp/cache/data.json", "{ \"ok\": true }\n")
    write_file("project/app/models/user.rb", "class User\nend\n")

    run_command_and_stop("copy_code -p txt project")

    output = read("project/code_output.txt")
    expect(output.any? { |line| line.include?("app/models/user.rb") }).to be(true)
    expect(output).not_to include("tmp/cache/data.json")
  end
end
