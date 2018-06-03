require 'open-uri'
require 'yaml'
# TODO: use Redmine's Redmine::Plugin
begin
  require 'redmine/plugin'
rescue LoadError
end
require 'redmine_audit/advisory'

module RedmineAudit
  # Redmine plugin advisory database
  class PluginDatabase
    URL = 'https://raw.githubusercontent.com/sho-h/redmine_audit/master/data/plugin_advisories.yml'

    # Get unfixed plugin advisories against specified Redmine version.
    #
    # @return [[Redmine::Advisory]]
    #   The array of plugin's Redmine::Advisory unfixed.
    def advisories
      if @known_advisories.nil?
        @known_advisories = {}
        YAML.load(fetch_advisory_data).each do |plugin_id, advisories|
          @known_advisories[plugin_id] ||= []
          advisories.each do |cve_id, attrs|
            unaffected_vers = (attrs['unaffected_versions'] || []).map { |ver|
              Gem::Requirement.new(ver)
            }
            patched_vers = (attrs['patched_versions'] || []).map { |ver|
              Gem::Requirement.new(ver)
            }
            args = [
              nil, attrs['title'], [attrs['url']],
              unaffected_vers, patched_vers,
              cve_id, attrs['cvss_v2'], attrs['cvss_v3'],
            ]
            @known_advisories[plugin_id] << Advisory.new(*args)
          end
        end
      end

      unfixed_advisories = {}
      Redmine::Plugin.all.each do |plugin|
        advisories = @known_advisories[plugin.id]
        next if advisories.nil? || advisories.empty?

        advisories.each do |advisory|
          if advisory.vulnerable?(Gem::Version.new(plugin.version))
            unfixed_advisories[plugin] ||= []
            unfixed_advisories[plugin].push(advisory)
          end
        end
      end
      return unfixed_advisories
    end

    private

    def fetch_advisory_data(url = URL)
      open(url).read
    end
  end
end
