require 'test_helper'
require 'test/unit'
require 'redmine_audit/advisory'

module RedmineAudit
  class AdvisoryTest < Test::Unit::TestCase
    test 'compare versions with >=' do
      req = Gem::Requirement.new('>= 0.1.0')
      advisory = Advisory.new('High', 'Test vulnerability', '', [], [req], nil, nil, nil)

      assert_equal(true,  advisory.vulnerable?(Gem::Version.new('0.0.9')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.0')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.1')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('1.0.0')))
    end

    test 'compare versions with ~>' do
      req = Gem::Requirement.new('~> 0.1.0')
      advisory = Advisory.new('High', 'Test vulnerability', '', [], [req], nil, nil, nil)

      assert_equal(true,  advisory.vulnerable?(Gem::Version.new('0.0.9')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.0')))
      assert_equal(false, advisory.vulnerable?(Gem::Version.new('0.1.1')))
      assert_equal(true,  advisory.vulnerable?(Gem::Version.new('1.0.0')))
    end

    test 'severity' do
      req = Gem::Requirement.new('>= 1.0.0')
      advisory = Advisory.new('Medium', 'vulnerability', '', [], [req], nil, 7.5, nil)
      assert_equal('Medium',  advisory.severity)

      advisory = Advisory.new('Medium', 'vulnerability', '', [], [req], nil ,nil, 7.5)
      assert_equal('Medium',  advisory.severity)

      [
        ['Low', [0.0, 3.9]],
        ['Medium', [4.0, 6.9]],
        ['High', [7.0, 10.0]],
      ].each do |expected, scores|
        scores.each do |score|
          advisory = Advisory.new(nil, 'vulnerability', '', [], [req], nil, score, nil)
          assert_equal(expected,  advisory.severity)
        end
      end

      [
        ['None', [0.0]],
        ['Low', [0.1, 3.9]],
        ['Medium', [4.0, 6.9]],
        ['High', [7.0, 8.9]],
        ['Critical', [9.0, 10.0]],
      ].each do |expected, scores|
        scores.each do |score|
          advisory = Advisory.new(nil, 'vulnerability', '', [], [req], nil, nil, score)
          assert_equal(expected,  advisory.severity)
        end
      end
    end
  end
end
