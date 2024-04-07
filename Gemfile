# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8'

gem 'bootsnap', require: false
gem 'rack-cors'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'activerecord-postgres_enum'
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
gem 'redis-rails'

gem 'dry-monads'
gem 'dry-schema'

group :development, :test do
  gem 'awesome_print'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'listen'
  gem 'pry', '~> 0.14.0'
  gem 'pry-byebug', '~> 3.10.0'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake'
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'fakeredis', require: 'fakeredis/rspec'
  gem 'rspec-rails'
  gem 'webmock', require: false
end
