require 'redmine_audit/version'

module RedmineAudit
  # Run the classic redmine plugin initializer after rails boot
  class Plugin < ::Rails::Engine
    config.after_initialize do
      require File.expand_path('../init', __dir__)
    end
  end
end
