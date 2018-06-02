module RedmineAudit
  # Redmine/Redmine plugin advisory
  #
  # ex)  Advisory.new('High', 'http://someurl.example.com',
  #                   [Gem::Requirement], [Gem::Requirement], nil, 7.5)
  Advisory = Struct.new(:severity,
                        :details,
                        :external_references,
                        :unaffected_versions,
                        :fixed_versions,
                        :id, :cvss_v2, :cvss_v3) do
    def initialize(severity, details, external_references,
                   unaffected_versions, fixed_versions, id, cvss_v2, cvss_v3)
      super
      self.severity = cvss_to_severity if self.severity.nil?
    end

    # Checks whether the version is not affected by the advisory.
    #
    # @param [Gem::Version] version
    #   The version to compare against {#unaffected_versions}.
    #
    # @return [Boolean]
    #   Specifies whether the version is not affected by the advisory.
    def unaffected?(version)
      unaffected_versions.any? do |unaffected_version|
        unaffected_version === version
      end
    end

    # Checks whether the version is fixed against the advisory.
    #
    # @param [Gem::Version] version
    #   The version to compare against {#fixed_versions}.
    #
    # @return [Boolean]
    #   Specifies whether the version is fixed against the advisory.
    def fixed?(version)
      fixed_versions.any? do |fixed_version|
        fixed_version === version
      end
    end

    # Checks whether the version is vulnerable to the advisory.
    #
    # @param [Gem::Version] version
    #   The version to compare against {#fixed_versions}.
    #
    # @return [Boolean]
    #   Specifies whether the version is vulnerable to the advisory or not.
    def vulnerable?(version)
      !fixed?(version) && !unaffected?(version)
    end

    private

    def cvss_to_severity
      if cvss_v2
        case cvss_v2
        when 0.0..3.9
          'Low'
        when 4.0..6.9
          'Medium'
        when 7.0..10.0
          'High'
        else
          raise ArgumentError, "invalid CVSS v2 score: #{cvss_v2}"
        end
      elsif cvss_v3
        case cvss_v3
        when 0.0
          'None'
        when 0.1..3.9
          'Low'
        when 4.0..6.9
          'Medium'
        when 7.0..8.9
          'High'
        when 9.0..10
          'Critical'
        else
          raise ArgumentError, "invalid CVSS v3 score: #{cvss_v3}"
        end
      end
    end
  end
end
