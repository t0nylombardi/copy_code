# frozen_string_literal: true

require "spec_helper"
require "copy_code/domain/filtering/ignore_rule"

RSpec.describe CopyCode::Domain::Filtering::IgnoreRule do
  describe ".from" do
    it "returns nil for empty patterns" do
      expect(described_class.from("")).to be_nil
      expect(described_class.from("   ")).to be_nil
    end
  end

  describe "#apply" do
    it "matches unanchored directory glob patterns" do
      rule = described_class.new("log*/")

      expect(rule.apply("app/logstash/output.txt", false)).to be(true)
      expect(rule.apply("tmp/output.txt", false)).to be(false)
    end

    it "matches anchored directory glob patterns" do
      rule = described_class.new("/log*/")

      expect(rule.apply("logstash/output.txt", false)).to be(true)
      expect(rule.apply("app/logstash/output.txt", false)).to be(false)
    end

    it "supports character classes and brace groups in directory rules" do
      class_rule = described_class.new("tmp[!a]/")
      brace_rule = described_class.new("{cache,tmp}/")

      expect(class_rule.apply("tmpb/file.txt", false)).to be(true)
      expect(class_rule.apply("tmpa/file.txt", false)).to be(false)
      expect(brace_rule.apply("cache/file.txt", false)).to be(true)
      expect(brace_rule.apply("tmp/file.txt", false)).to be(true)
    end

    it "handles double-star directory patterns" do
      rule = described_class.new("**/build/")

      expect(rule.apply("build/output.txt", false)).to be(true)
      expect(rule.apply("dist/build/output.txt", false)).to be(true)
      expect(rule.apply("dist/output.txt", false)).to be(false)
    end
  end
end
