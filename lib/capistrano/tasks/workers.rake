namespace :workers do
  %w[start stop].each do |task_name|
    desc "#{task_name.capitalize} all workers"
    task task_name do
      on roles(:resque) do
        rails_env = fetch(:rails_env, nil)
        current_release = fetch(:current_release)
        # stdout and stderr redirected. if there is a problem in a step here see the remote
        # log at log/cap_workers_task.log
        run "cd #{current_release} && rails_env=#{rails_env} nohup #{rake} workers:#{task_name} > #{current_release}/log/cap_workers_task.log 2>&1"
      end
    end
  end

  desc "Restart all workers"
  task :restart do
    on roles(:resque) do
      # Kill the Watcher and let cron restart it
      sudo 'pkill -o -f KEWatcher || true'
    end
  end

  after 'deploy:updated', 'workers:restart'
end
