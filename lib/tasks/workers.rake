require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'resque-sliders'

namespace :workers do
  def redis_instance
    @inst ||= begin
                config_filepath = Rails.root.join('config', 'redis.yml')
                config = YAML.load_file config_filepath
                Redis.new config[ENV['RAILS_ENV']]
              end
  end

  def redis_url
    config_filepath = Rails.root.join('config', 'redis.yml')
    config = YAML.load_file config_filepath
    config = config[ENV['RAILS_ENV']]
    "redis://:#{config['password']}@#{config['host']}:#{config['port']}/#{config['db']}"
  end

  desc "stop all resque workers"
  task :stop => :environment do
    dc = Resque::Plugins::ResqueSliders::DistributedCommander.new
    dc.stop_all_hosts!
  end

  desc "Removes all occurences of a worker from resque (useful for when a worker dies and Resque-Sliders fails to rebalance workers)"
  task :stomp_worker, [:worker_number] => :environment do |t, args|
    worker_num = args[:worker_number]
    worker_suffix = "work#{worker_num}"
    redis = redis_instance
    redis.keys("*#{worker_suffix}*").each do |key|
      redis.del key
    end
    host_config_key = redis.keys("*sliders:host_configs*").first
    sliders_host_config = redis.hgetall(host_config_key)
    delete_us = sliders_host_config.keys.select{|key| key =~/#{worker_suffix}/}
    delete_us.each do |delete_me|
      redis.hdel(host_config_key, delete_me)
    end
  end

  desc "start all resque workers"
  task :start => :environment do
    log = Rails.root.join(*%w{log kewatcher_pid_file})
    rake_path = Rails.root.join "Rakefile"
    cmd = "kewatcher -c #{redis_url} -r #{rake_path} -m500 -p #{log} "
    puts cmd
    (pid = fork) ? Process.detach(pid) : exec(cmd)
    dc = Resque::Plugins::ResqueSliders::DistributedCommander.new
    dc.start_all_hosts!
  end

  desc "ensure kewatchers are up"
  task :check_kewatcher => :environment do
    log = Rails.root.join(*%w{log kewatcher_pid_file})
    rake_path = Rails.root.join "Rakefile"
    cmd = "kewatcher -c #{redis_url} -r #{rake_path} -m500 -p #{log} "
    puts cmd
    (pid = fork) ? Process.detach(pid) : exec(cmd)
  end

  desc "restart the worker herd"
  task :restart => :environment do
    log = Rails.root.join(*%w{log kewatcher_pid_file})
    rake_path = Rails.root.join "Rakefile"
    cmd = "kewatcher -c #{redis_url} -r #{rake_path} -m500 -p #{log} -f"
    puts cmd
    (pid = fork) ? Process.detach(pid) : exec(cmd)
    dc = Resque::Plugins::ResqueSliders::DistributedCommander.new
    dc.start_all_hosts!
  end
end
