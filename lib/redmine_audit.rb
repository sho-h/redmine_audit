require 'redmine_audit/version'

module RedmineAudit
  # Run the classic redmine plugin initializer after rails boot
  class Plugin < ::Rails::Engine
    config.after_initialize do
      require File.expand_path('../init', __dir__)

      create_hint = true
      # TODO: support Redmine 3.4.0
      plugins_dir = File.join(Bundler.root, 'plugins')
      Dir.glob(File.join(plugins_dir, '*/redmine_audit.gemspec')) do |gemspec_path|
        Rails.logger.warn('Skip to load redmine_audit plugin installed as gem.')
        Rails.logger.warn('Use plugins directory\'s redmine_audit plugin')
        create_hint = false
      end

      if create_hint
        # Create text file to Redmine's plugins directory.
        # The purpose is telling plugins directory to users.
        path = File.join(plugins_dir, 'redmine_audit')
        if !File.exists?(path)
          File.open(path, 'w') do |f|
            f.write(<<EOS)
This plugin was installed as gem wrote to Gemfile.local instead of putting Redmine's plugin directory.
See redmine_audit gem installed directory.
EOS
          end
        end
      end
    end
  end
end
