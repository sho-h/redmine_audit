# RedmineAudit

This is Redmine plugin for checking vulnerabilities. provides redmine:audit rake task.

## Installation

Add this line to your Redmine's Gemfile.local:

```ruby
gem 'redmine_audit'
```

And then execute:

    $ bundle

Or git clone under Redmine's plugins directory.

```
$ cd /path/to/redmine/plugins && git clone https://github.com/sho-h/redmine_audit.git
```

## Uninstallation

Remove above line from your Redmine's Gemfile.local.

And remove file(s) this gem installed(or you cloned).

```
$ cd /path/to/redmine/plugins && rm -rf ./redmine_audit
```

## Usage

Excecute redmine:audit rake task with users environment variable.

```
$ rake redmine:audit users=1,2 RAILS_ENV=production
```

Or, add same commant to crontab.

```
30 6 * * * www-data perl -e 'sleep int(rand(3600))' && cd /path/to/redmine ; rake redmine:audit users=1,2 RAILS_ENV=production
```

Send email if vulnerabilities found. users environment variable can set only system administrator.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sho-h/redmine_audit.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

