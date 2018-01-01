# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, 'nature-photocompetition'
set :repo_url, "https://github.com/infernalmaster/nature-photocompetition.git"

# ssh_options = {keys: ["#{ENV['HOME']}/.ssh/dev.pem"], forward_agent: true}

# role :web, '159.89.30.17'                          # Your HTTP server, Apache/etc
# role :app, '159.89.30.17'                          # This may be the same as your `Web` server
# role :db,  '159.89.30.17', primary: true # This is where Rails migrations will run

server "159.89.30.17", user: "deploy", roles: %w[web app db]

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby}
set :rbenv_roles, :all # default value


# # set :user, 'root'
# # set :use_sudo, false
# set :bundle_without, %i[development test]
# # set :bundle_dir,      File.join(fetch(:shared_path), 'gems')

# set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"
# set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
# set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# set :unicorn_start_cmd, "(cd #{deploy_to}/current; bundle exec unicorn -E production -Dc #{fetch :unicorn_conf})"

# # set :default_environment, 'PATH' => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH'

# # set :shared_children, shared_children + %w[public/uploads]

# task :copy_db, roles: :app do
#   app_db = "#{shared_path}/production.db"
#   run "ln -s #{app_db} #{release_path}/production.db"
# end
# task :copy_settings, roles: :app do
#   app_db = "#{shared_path}/settings.rb"
#   run "cp #{app_db} #{release_path}/settings.rb"
# end
# after 'deploy:update_code', :copy_settings, :copy_db

# # set (:bundle_cmd) { "#{release_path}/bin/bundle" }
# # set :bundle_flags, "--deployment --quiet --binstubs"

# # - for unicorn - #
# namespace :deploy do
#   desc 'Start application'
#   task :start, roles: :app do
#     run unicorn_start_cmd
#   end

#   desc 'Stop application'
#   task :stop, roles: :app do
#     run "[ -f #{fetch :unicorn_pid} ] && kill -QUIT `cat #{fetch :unicorn_pid}`"
#   end

#   desc 'Restart Application'
#   task :restart, roles: :app do
#     run "[ -f #{fetch :unicorn_pid} ] && kill -USR2 `cat #{fetch :unicorn_pid}` || #{fetch :unicorn_start_cmd}"
#   end
# end

# desc 'Use datamapper to call autoupgrade instead of db:migrate.'
# task :migrate, roles: :app do
#   run "cd #{deploy_to}/current; bundle exec rake db:migrate RACK_ENV=production"
# end




# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
