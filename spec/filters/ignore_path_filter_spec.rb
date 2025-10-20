# frozen_string_literal: true

require "spec_helper"
require "copy_code/filters/ignore_path_filter"
require "tmpdir"

RSpec.describe CopyCode::Filters::IgnorePathFilter do
  describe "#exclude?" do
    it "returns false when no patterns are configured" do
      Dir.mktmpdir do |dir|
        filter = described_class.new([], root: dir)

        expect(filter.exclude?(File.join(dir, "app/models/user.rb"))).to be(false)
      end
    end

    it "excludes files matching directory rules" do
      Dir.mktmpdir do |dir|
        filter = described_class.new(["tmp/"], root: dir)

        expect(filter.exclude?(File.join(dir, "tmp/cache/data.json"))).to be(true)
        expect(filter.exclude?(File.join(dir, "lib/tmp_helper.rb"))).to be(false)
      end
    end

    it "honors negated patterns to re-include files" do
      Dir.mktmpdir do |dir|
        filter = described_class.new(["tmp/", "!tmp/keep.log"], root: dir)

        expect(filter.exclude?(File.join(dir, "tmp/keep.log"))).to be(false)
      end
    end

    it "leaves files outside the root unfiltered" do
      Dir.mktmpdir do |dir|
        filter = described_class.new(["*.log"], root: File.join(dir, "project"))
        file = File.join(dir, "outside.log")

        expect(filter.exclude?(file)).to be(false)
      end
    end
  end
end
