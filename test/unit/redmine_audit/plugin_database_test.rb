require 'test_helper'
require 'test/unit'
require 'test/unit/rr'
require 'redmine_audit/plugin_database'

begin
  require 'redmine/plugin'
rescue LoadError
  module Redmine
    class Plugin
      @registered_plugins = {}
      class << self
        attr_reader :registered_plugins

        def def_field(*names)
          class_eval do
            names.each do |name|
              define_method(name) do |*args|
                args.empty? ? instance_variable_get("@#{name}") : instance_variable_set("@#{name}", *args)
              end
            end
          end
        end

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

      def initialize(id)
        @id = id.to_sym
      end

      def_field :name, :version
      attr_reader :id
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
      _ver = '0.6.0'
      _name = 'Redmine Git Hosting Plugin'
      Redmine::Plugin.register(:redmine_git_hosting) { version _ver; name _name }
      plugin, advisories = *@database.advisories.first
      assert_equal('Redmine Git Hosting Plugin', plugin.name)
      assert_equal('CVE-2013-4663', advisories[0].id)
      assert_equal(1, advisories.length)
      assert_equal(1, @database.advisories.length)
    end

    test 'compare versions with not vulnerable plugin' do
      _ver = '1.0.0'
      _name = 'Redmine Git Hosting Plugin'
      Redmine::Plugin.register(:redmine_git_hosting) { version _ver; name _name }
      assert_equal({}, @database.advisories)
    end
  end
end
