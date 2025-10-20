# frozen_string_literal: true

require "spec_helper"
require "copy_code/domain/filtering/relative_path_resolver"
require "tmpdir"

RSpec.describe CopyCode::Domain::Filtering::RelativePathResolver do
  describe "#call" do
    it "returns the path relative to the configured root" do
      Dir.mktmpdir do |dir|
        resolver = described_class.new(root: dir)
        file = File.join(dir, "app/models/user.rb")

        expect(resolver.call(file)).to eq("app/models/user.rb")
      end
    end

    it "returns the absolute path when file is outside the root" do
      Dir.mktmpdir do |dir|
        resolver = described_class.new(root: File.join(dir, "project"))
        file = File.join(dir, "outside.rb")

        expect(resolver.call(file)).to eq(File.expand_path(file))
      end
    end
  end
end
