require 'test_helper'
require 'test/unit'
require 'mocha/test_unit'
require 'redmine_audit/database'

module RedmineAudit
  class DatabaseTest < Test::Unit::TestCase
    setup do
      @database = Database.new
      path = File.expand_path('../../data/Security_Advisories', __dir__)
      @database.stubs(:fetch_advisory_data).returns(File.read(path))
    end

    test 'compare versions with >=' do
      assert_equal([], @database.advisories('3.4.0'))
      assert_equal([], @database.advisories('3.3.3'))
      assert_equal([], @database.advisories('3.3.3.stable'))
      assert_equal([], @database.advisories('3.2.6'))

      assert_equal(6, @database.advisories('3.3.2').length)
      assert_equal(6, @database.advisories('3.2.5').length)
      assert_equal(6, @database.advisories('3.2.3').length)
      assert_equal(7, @database.advisories('3.2.2').length)

      # treated as prerelease by Gem::Version.
      assert_equal(6, @database.advisories('3.3.3.devel').length)
    end
  end
end
