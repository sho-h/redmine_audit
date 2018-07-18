#!/bin/sh

git clone --branch=${REDMINE_VER} https://github.com/redmine/redmine.git
cp /database.yml /redmine/config/
git clone --branch=${BRANCH} https://github.com/sho-h/redmine_audit.git /redmine/plugins/redmine_audit
cd /redmine && \
   bundle install --without rmagick && \
   bundle exec rake db:migrate &&
   bundle exec rake redmine:plugins:test
