module RedmineAudit
  # Redmine advisory
  #
  # ex)  Advisory.new('High', 'http://someurl.example.com',
  #                   [Gem::Requirement], [Gem::Requirement])
  class Advisory < Struct.new(:severity,
                              :details,
                              :external_references,
                              :unaffected_versions,
                              :fixed_versions)
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
  end
end
