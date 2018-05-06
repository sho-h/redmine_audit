require 'redmine/version'
require 'redmine_audit/advisory'
require 'redmine_audit/database'
require 'bundler/audit/scanner'

desc <<-END_DESC
Check redmine vulnerabilities.

Available options:
  * users => comma separated list of user/group ids who should be notified
  * dont_bundler_audit => don't bundler audit if '1' specified

Example:
  rake redmine:audit users="1,23, 56" RAILS_ENV="production"
END_DESC

namespace :redmine do
  task audit: :environment do
    user_ids = (ENV['users'] || '').split(',').each(&:strip!)
    if user_ids.empty?
      raise 'need to specify environment variable: users'
    end

    users = User.active.where(admin: true, id: user_ids).to_a
    if users.empty?
      raise ActiveRecord::RecordNotFound.new("Couldn't find user specified: #{user_ids.inspect}")
    end

    # TODO: More better if requires mailer automatically.
    require_dependency 'mailer'
    require_relative '../../app/models/mailer.rb'
    Rake::Task['redmine:audit:redmine'].invoke(users)
    unless ENV['dont_bundler_audit'] == '1'
      Rake::Task['redmine:audit:bundler'].invoke(users)
    end
  end

  namespace :audit do
    task :redmine, [:users] do |t, args|
      redmine_ver = Redmine::VERSION.to_s
      advisories = RedmineAudit::Database.new.advisories(redmine_ver)
      if advisories.length > 0
        Mailer.with_synched_deliveries do
          Mailer.unfixed_redmine_advisories_found(redmine_ver, advisories, args.users).deliver
        end
      end
    end

    # Update ruby-advisory-db.
    task :update_ruby_advisory_db do
      Bundler::Audit::Database.update!(quiet: true)
    end

    task :bundler, [:users] => :update_ruby_advisory_db do |t, args|
      scan_result = Bundler::Audit::Scanner.new.scan
      if scan_result.count > 0
        Mailer.with_synched_deliveries do
          Mailer.unfixed_gemfile_advisories_found(scan_result, args.users).deliver
        end
      end
    end
  end
end
