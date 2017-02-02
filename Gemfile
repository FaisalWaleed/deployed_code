source 'https://rubygems.org'

gem 'rails', '3.2.22'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2', '~> 0.3.11'
gem 'sqlite3'
gem 'resque'
gem 'resque-scheduler', '~> 4.0.0'
gem 'resque-retry', require: nil
gem 'resque-cleaner'
gem 'resque-sliders', git: 'git://github.com/seomoz/resque-sliders'
gem 'sinatra', require: nil
gem 'capybara', '~> 2.7.0'
gem 'poltergeist'
gem 'headless'
#gem 'capybara-webkit', '~> 1.11.0', require: nil
gem 'simple_form'
gem 'whenever'
gem 'pickup'
gem 'activeadmin'
gem 'kaminari'

# Plus integrations with:
gem 'devise'
gem 'jquery-ui-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 3.3.5'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'test-unit', require: false

# Use unicorn as the app server
gem 'unicorn'

group :development do
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-unicorn-nginx'
  gem 'capistrano-ssh-doctor'
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
end
