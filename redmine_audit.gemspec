# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redmine_audit/version'

Gem::Specification.new do |spec|
  spec.name          = 'redmine_audit'
  spec.version       = RedmineAudit::VERSION
  spec.authors       = ['Sho Hashimoto']
  spec.email         = ['sho.hsmt@gmail.com']

  spec.summary       = %q{Redmine plugin for checking Redmine's own vulnerabilities}
  spec.description   = %q{Redmine plugin for checking Redmine's own vulnerabilities}
  spec.homepage      = 'https://github.com/sho-h/redmine_audit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^((test|spec|features)/|Gemfile)})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'bundler-audit'
  spec.add_runtime_dependency 'ruby_audit'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'travis'
end
