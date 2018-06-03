# reopen Redmine Mailer
class Mailer < ActionMailer::Base
  helper :redmine_audit

  # Sends notification to specified administrator
  #
  # @param [Gem::Version] redmine_version
  #   The version to compare against {#unaffected_versions}.
  # @param [RedmineAudit::Advisory] advisories
  #   Array of Redmine advisories.
  # @param [RedmineAudit::Advisory] plugin_advisories
  #   Array of plugin's Redmine advisories.
  # @param [Array] users
  #   Array of users who should be notified.
  def unfixed_redmine_advisories_found(redmine_version, redmine_advisories, plugin_advisories, users)
    return if (redmine_advisories.nil? || redmine_advisories.empty?) && (plugin_advisories.nil? || plugin_advisories.empty?)

    @redmine_version = redmine_version
    @advisories = redmine_advisories || []
    @plugin_advisories = plugin_advisories || []
    # TODO: Internationalize subject.
    mail(to: users, subject: "[Redmine] Security notification")
  end

  # Sends Redmine depend gem security notification to specified administrator
  #
  # @param [Enumerator] ruby_result
  #   The Enumerator of Redmine depend ruby advisories.
  # @param [Enumerator] gems_result
  #   The Enumerator of Redmine depend gem advisories.
  # @param [Array] users
  #   Array of users who should be notified.
  def unfixed_ruby_and_gems_advisories_found(ruby_result, gems_result, users)
    return if (ruby_result.nil? || ruby_result.count.zero?) && (gems_result.nil? || gems_result.count.zero?)

    @ruby_result = ruby_result || []
    @gems_result = gems_result || []
    # TODO: Internationalize subject.
    mail(to: users, subject: "[Redmine] Ruby/Depend gem security notification")
  end
end
