require 'test_helper'
require 'test/unit'
require 'test/unit/rr'
require 'redmine_audit/plugin_database'

# TODO: use Redmine's Redmine::Plugin
module Redmine
  Plugin = Struct.new(:id, :name, :description, :url, :author, :author_url, :version, :settings, :directory) do
    @registered_plugins = {}
    class << self
      attr_reader :registered_plugins

      def register(id, &block)
        plugin = new(id)
        plugin.instance_eval(&block)
        registered_plugins[id] = plugin
      end

      def all
        registered_plugins.values.sort
      end

      def clear
        registered_plugins = {}
      end
    end
  end
end

module RedmineAudit
  class PluginDatabaseTest < Test::Unit::TestCase
    setup do
      @database = PluginDatabase.new
      path = File.expand_path('../../../data/plugin_advisories.yml', __dir__)
      mock(@database).fetch_advisory_data { File.read(path) }
    end

    teardown do
      Redmine::Plugin.clear
    end

    test 'compare versions with vulnerable plugin' do
      ver = '0.6.0'
      name = 'Redmine Git Hosting Plugin'
      Redmine::Plugin.register(:redmine_git_hosting) { self.version = ver; self.name = name }
      plugin, advisories = *@database.advisories.first
      assert_equal('Redmine Git Hosting Plugin', plugin.name)
      assert_equal('CVE-2013-4663', advisories[0].id)
      assert_equal(1, advisories.length)
      assert_equal(1, @database.advisories.length)
    end

    test 'compare versions with not vulnerable plugin' do
      ver = '1.0.0'
      name = 'Redmine Git Hosting Plugin'
      Redmine::Plugin.register(:redmine_git_hosting) { self.version = ver; self.name = name }
      assert_equal({}, @database.advisories)
    end
  end
end
