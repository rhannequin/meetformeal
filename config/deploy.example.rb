# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'funky-starter-plus-plus'
set :repo_url, 'https://example.com/repo.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> { "/directory/#{fetch(:application)}" }

# Default value for :scm is :git
# set :scm, :git

# Only one git clone, then git pull
set :deploy_via, :remote_cache

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rbenv setup
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_path, '$HOME/.rbenv'

# Bundler setup
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_without, %w{development test}.join(' ')
set :bundle_flags, '--deployment --quiet --binstubs --clean'
set :bundle_jobs, 4

# Environment PATH
set :default_environment, {
  'PATH' => './bin:$PATH'
}

# Clean
set :keep_releases, 5
after 'deploy', 'deploy:cleanup'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
