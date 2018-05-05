# reopen Redmine Mailer
class Mailer < ActionMailer::Base
  # Sends notification to specified administrator
  #
  # @param [Gem::Version] redmine_version
  #   The version to compare against {#unaffected_versions}.
  # @param [RedmineAudit::Advisory] advisories
  #   Array of Redmine advisories.
  # @param [Array] user_ids
  #   Array of user ids who should be notified.
  def unfixed_advisories_found(redmine_version, advisories, user_ids)
    return if advisories.nil? || advisories.empty?

    users = User.active.where(admin: true, id: user_ids).to_a
    if users.empty?
      raise ActiveRecord::RecordNotFound.new("Couldn't find user specified: #{user_ids.inspect}")
    end

    @redmine_version = redmine_version
    @advisories = advisories
    # TODO: Internationalize suject and body.
    mail(to: users, subject: "[Redmine] Security notification")
  end
end
