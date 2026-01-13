# frozen_string_literal: true

require "spec_helper"
require "copy_code/domain/filtering/ignore_rule_set"

RSpec.describe CopyCode::Domain::Filtering::IgnoreRuleSet do
  describe "#ignored?" do
    it "returns false when no rules exist" do
      rule_set = described_class.new([])

      expect(rule_set.ignored?("app/models/user.rb")).to be(false)
    end

    it "ignores files matching simple glob rules" do
      rule_set = described_class.new(["*.log"])

      expect(rule_set.ignored?("log/development.log")).to be(true)
      expect(rule_set.ignored?("app/models/user.rb")).to be(false)
    end

    it "supports directory rules with trailing slashes" do
      rule_set = described_class.new(["tmp/"])
      expect(rule_set.ignored?("tmp")).to be(true)
      expect(rule_set.ignored?("tmp/cache/data.json")).to be(true)
      expect(rule_set.ignored?("lib/tmp_helpers.rb")).to be(false)
    end

    it "supports anchored directory rules" do
      rule_set = described_class.new(["/build"])

      expect(rule_set.ignored?("build/output.txt")).to be(true)
      expect(rule_set.ignored?("dist/build/output.txt")).to be(false)
    end

    it "supports negated rules to re-include paths" do
      rule_set = described_class.new(["*.log", "!important.log"])

      expect(rule_set.ignored?("other.log")).to be(true)
      expect(rule_set.ignored?("important.log")).to be(false)
    end

    it "applies rules in order" do
      rule_set = described_class.new(["!*.rb", "*.rb"])

      expect(rule_set.ignored?("app/models/user.rb")).to be(true)
    end
  end
end
