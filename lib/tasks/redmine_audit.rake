require 'redmine/version'
require 'redmine_audit/advisory'
require 'redmine_audit/database'
# TODO: require mailer automatically.
require_relative '../../app/models/mailer.rb'

desc <<-END_DESC
Check redmine vulnerabilities.

Available options:
  * users    => comma separated list of user/group ids who should be notified

Example:
  rake redmine:bundle_audit users="1,23, 56" RAILS_ENV="production"
END_DESC

namespace :redmine do
  task audit: :environment do
    redmine_ver = Redmine::VERSION
    advisories = RedmineAudit::Database.new.advisories(redmine_ver.to_s)
    if advisories.length > 0
      users = (ENV['USERS'] || '').split(',').each(&:strip!)
      # comment in Mailer.with_synched_deliveries block. need to require Redmine's Mailer
      # Mailer.with_synched_deliveries do
        Mailer.unfixed_advisories_found(advisories, users).deliver
      # end
    end
  end
end
