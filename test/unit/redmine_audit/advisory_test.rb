require 'test_helper'
require 'test/unit'
require 'redmine_audit/advisory'

module RedmineAudit
  class AdvisoryTest < Test::Unit::TestCase
    test 'compare versions with >=' do
      req = Gem::Requirement.new('>= 0.1.0')
      advisory = Advisory.new('High', 'Test vulnerability', '', [], [req])

      assert_equal(true,  advisory.vulnerable?(Gem::Version.new('0.0.9')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.0')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.1')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('1.0.0')))
    end

    test 'compare versions with ~>' do
      req = Gem::Requirement.new('~> 0.1.0')
      advisory = Advisory.new('High', 'Test vulnerability', '', [], [req])

      assert_equal(true,  advisory.vulnerable?(Gem::Version.new('0.0.9')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.0')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.1')))
      assert_equal(true,  advisory.vulnerable?(Gem::Version.new('1.0.0')))
    end
  end
end
