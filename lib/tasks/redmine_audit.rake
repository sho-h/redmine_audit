require 'redmine/version'
require 'redmine_audit/advisory'
require 'redmine_audit/database'

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
      options = {}
      options[:users] = (ENV['users'] || '').split(',').each(&:strip!)
      Mailer.with_synched_deliveries do
        # TODO: send mail
      end
    end
  end
end
