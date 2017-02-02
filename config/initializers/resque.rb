require 'resque'
require 'redis'
require 'resque-scheduler'
require 'resque/scheduler/server'

config_filepath = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'redis.yml')
config = YAML.load_file config_filepath
env = ENV['RAILS_ENV'] || Rails.env
redis = Redis.new config[env] || {host: '127.0.0.1'}
Resque.redis = redis
