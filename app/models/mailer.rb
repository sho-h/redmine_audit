# reopen Redmine Mailer
class Mailer < ActionMailer::Base
  helper :redmine_audit

  # Sends notification to specified administrator
  #
  # @param [Gem::Version] redmine_version
  #   The version to compare against {#unaffected_versions}.
  # @param [RedmineAudit::Advisory] advisories
  #   Array of Redmine advisories.
  # @param [Array] users
  #   Array of users who should be notified.
  def unfixed_redmine_advisories_found(redmine_version, redmine_advisories, users)
    return if redmine_advisories.nil? || redmine_advisories.empty?

    @redmine_version = redmine_version
    @advisories = redmine_advisories
    # TODO: Internationalize subject.
    mail(to: users, subject: "[Redmine] Security notification")
  end

  # Sends Redmine depend gem security notification to specified administrator
  #
  # @param [Enumerator] scan_result
  #   The Enumerator of Redmine depend gem advisories.
  # @param [Array] users
  #   Array of users who should be notified.
  def unfixed_gemfile_advisories_found(scan_result, users)
    return if scan_result.nil? || scan_result.count.zero?

    @scan_result = scan_result
    # TODO: Internationalize subject.
    mail(to: users, subject: "[Redmine] Depend gem security notification")
  end
end
