# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'botly1'
set :repo_url, 'git@gitlab.com:botly/botly1.git'
set :rbenv_ruby, '2.3.1'

set :deploy_to, '/home/botly'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/redis.yml')

set :whenever_roles, -> { [:web, :resque, :retry] }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :touch, 'tmp/restart.txt'
      end
    end
  end
end

namespace :git do
  task :update_repo_url do
    on roles(:all) do
      within repo_path do
        execute :git, 'remote', 'set-url', 'origin', fetch(:repo_url)
      end
    end
  end
end

namespace :logrotate do
  desc 'Upload logrotate'
  task :setup do
    on roles(:all) do
      within release_path do
        execute :sudo, :cp, 'config/logrotate', '/etc/logrotate.d/botly'
      end
    end
  end
end
