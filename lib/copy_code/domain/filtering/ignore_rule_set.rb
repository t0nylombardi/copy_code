# frozen_string_literal: true

module CopyCode
  module Domain
    module Filtering
      # IgnoreRuleSet aggregates ordered ignore rules and evaluates them.
      class IgnoreRuleSet
        def initialize(patterns)
          @rules = build_rules(patterns)
        end

        # @param path [String] relative path from the root
        # @return [Boolean] whether the path should be ignored
        def ignored?(path)
          ignored = false
          @rules.each do |rule|
            ignored = rule.apply(path, ignored)
          end
          ignored
        end

        def empty?
          @rules.empty?
        end

        private

        def build_rules(patterns)
          Array(patterns).filter_map do |pattern|
            IgnoreRule.from(pattern)
          end
        end
      end
    end
  end
end
