# frozen_string_literal: true

require "spec_helper"
require "copy_code/domain/filtering/pattern_whitelist"

RSpec.describe CopyCode::Domain::Filtering::PatternWhitelist do
  describe "#include?" do
    context "when no patterns are provided" do
      it "includes any file" do
        whitelist = described_class.new([])

        expect(whitelist.include?("/project/app/models/user.rb")).to be(true)
        expect(whitelist.include?("/project/app/models/user.py")).to be(true)
      end
    end

    context "when simple extensions are provided" do
      it "includes files matching the extension" do
        whitelist = described_class.new(%w[rb py])

        expect(whitelist.include?("/project/app/models/user.rb")).to be(true)
        expect(whitelist.include?("/project/scripts/tool.py")).to be(true)
      end

      it "excludes files with non-matching extensions" do
        whitelist = described_class.new(%w[rb])

        expect(whitelist.include?("/project/public/app.js")).to be(false)
      end
    end

    context "when extensions include a leading dot" do
      it "normalizes and matches the extension" do
        whitelist = described_class.new([".rb"])

        expect(whitelist.include?("/project/main.rb")).to be(true)
        expect(whitelist.include?("/project/main.py")).to be(false)
      end
    end

    context "when glob patterns are provided" do
      it "matches basenames using the glob" do
        whitelist = described_class.new(["*_spec.rb"])

        expect(whitelist.include?("/project/spec/user_spec.rb")).to be(true)
        expect(whitelist.include?("/project/spec/user_helper.rb")).to be(false)
      end
    end

    context "when patterns include whitespace" do
      it "strips whitespace before evaluating" do
        whitelist = described_class.new(["  rb  "])

        expect(whitelist.include?("/project/app/models/user.rb")).to be(true)
      end
    end
  end
end
