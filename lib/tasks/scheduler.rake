desc 'Runs the scheduler'
task schedule: :environment do
  Scheduler.perform
end
