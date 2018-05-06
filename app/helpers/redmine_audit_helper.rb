module RedmineAuditHelper
  def gem_advisory(advisory)
    # See bundler-audit/lib/bundler/audit/cli.rb
    if advisory.cve
      return "CVE-#{advisory.cve}"
    elsif advisory.osvdb
      return advisory.osvdb
    else
      # Changing from bundler-audit instead of nil returns.
      return "Unknown"
    end
  end

  def gem_criticality(advisory)
    # See bundler-audit/lib/bundler/audit/cli.rb
    return (advisory.criticality || 'Unknown').to_s.capitalize
  end
end
