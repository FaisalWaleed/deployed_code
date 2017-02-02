# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
1
2
job_type :bundled_rake, %{export PATH=/home/botly/.rbenv/shims:/home/botly/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=:environment script/run_cron_task :task bundle exec rake :task --silent :output}

every 1.hour, roles: [:retry] do
  bundled_rake 'schedule'
end

every 1.minute, roles: [:resque] do
  bundled_rake 'workers:check_kewatcher'
end

every 1.week, roles: [:retry] do
  runner 'Session.clean_up_old_sessions'
end
