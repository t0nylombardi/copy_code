# frozen_string_literal: true

require "spec_helper"
require "copy_code/filters/file_extension_filter"

RSpec.describe CopyCode::Filters::FileExtensionFilter do
  describe "#exclude?" do
    it "returns false when no extensions are configured" do
      filter = described_class.new([])

      expect(filter.exclude?("/project/app/models/user.rb")).to be(false)
      expect(filter.exclude?("/project/app/models/user.py")).to be(false)
    end

    it "excludes files without matching extensions" do
      filter = described_class.new(["rb"])

      expect(filter.exclude?("/project/app/models/user.rb")).to be(false)
      expect(filter.exclude?("/project/app/models/user.py")).to be(true)
    end

    it "respects glob patterns" do
      filter = described_class.new(["*_spec.rb"])

      expect(filter.exclude?("/project/spec/user_spec.rb")).to be(false)
      expect(filter.exclude?("/project/spec/user_helper.rb")).to be(true)
    end
  end
end
