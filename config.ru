# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque'

if Rails.env.production?
  require_relative 'config/initializers/resque'
end

app = Rack::URLMap.new(
  '/' => Botly::Application,
  '/resque' => Resque::Server.new
)

unless Rails.env.staging? || Rails.env.development?
  app = Rack::Auth::Basic.new(app) do |un, pw|
    un == 'botlyadmin' && pw == 'Botly2015'
  end
end

run app
