require 'bundler/capistrano'

set :application, "blackwood"

set :rvm_ruby_string, "ruby-1.9.3-p125"
require "rvm/capistrano" # Load RVM's capistrano plugin.

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', "ubuntu:required_packages"
before 'deploy:setup', 'ubuntu:service_gems'

task :production do
  set :gateway, 'beagle.placeling.com:11235'
  server '10.122.167.104', :app, :web, :db, :scheduler, :primary => true
  ssh_options[:forward_agent] = true #forwards local-localhost keys through gateway
  set :user, 'ubuntu'
  set :use_sudo, false
  set :rails_env, "production"
end

task :staging do
  server 'staging.placeling.com', :app, :web, :db, :scheduler, :primary => true
  ssh_options[:forward_agent] = true
  set :deploy_via, :remote_cache
  set :user, 'ubuntu'
  set :port, '11235'
  set :use_sudo, false
  set :rails_env, "staging"
end

default_run_options[:pty] = true # Must be set for the password prompt from git to work
set :repository, "git@github.com:placeling/Blackwood.git" # Your clone URL
set :scm, "git"

set :deploy_to, "/var/www/apps/#{application}"
set :shared_directory, "#{deploy_to}/shared"
set :deploy_via, :remote_cache

namespace :ubuntu do
  task :required_packages, :roles => :app do
    run 'sudo apt-get update'
    run 'sudo apt-get install git-core ruby  ruby-dev rubygems libxslt-dev libxml2-dev libcurl4-openssl-dev imagemagick nodejs'
    run 'sudo apt-get install zlib1g-dev libssl-dev libyaml-dev libsqlite3-0  libsqlite3-dev sqlite3 libxml2-dev libxslt-dev  autoconf libc6-dev ncurses-dev'
    run 'sudo apt-get install build-essential bison openssl libreadline6 libreadline6-dev curl libtool libpcre3 libpcre3-dev'
  end

  task :service_gems, :roles => :app do
    run 'sudo gem install bundler passenger scout request-log-analyzer'
  end
end


namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Restart Resque Workers"
  task :restart_workers, :roles => :app do
    run_remote_rake "resque:restart_workers"
  end

  desc "Restart Resque scheduler"
  task :restart_scheduler, :roles => :scheduler do
    run_remote_rake "resque:restart_scheduler"
  end

end

require './config/boot'