Redmine::Plugin.register :redmine_audit do
  name 'Redmine Audit plugin'
  author 'Sho Hashimoto'
  description 'Redmine plugin for checking Redmine\'s own vulnerabilities'
  version RedmineAudit::VERSION
  requires_redmine version_or_higher: '3.3.0'
  url 'https://github.com/sho-h/redmine_audit/'
  author_url 'https://github.com/sho-h/'
  directory __dir__
end
