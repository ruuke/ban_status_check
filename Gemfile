# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.0.8'

gem 'pg', '~> 1.1'

gem 'puma', '~> 5.0'

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'bootsnap', require: false

gem 'rack-cors'

gem 'activerecord-postgres_enum'
gem 'hiredis'
gem 'redis', '< 5', require: ['redis', 'redis/connection/hiredis']
gem 'redis-rails'

gem 'dry-monads'
gem 'dry-schema'

group :development, :test do
  gem 'dotenv'
  gem 'awesome_print'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
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

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'fakeredis', require: 'fakeredis/rspec'
  gem 'fuubar', require: false
  gem 'rspec-its', require: false
  gem 'rspec-json_matchers', require: false
  gem 'rspec_junit_formatter', require: false
  gem 'rspec-rails'
  gem 'saharspec', require: false
  gem 'shoulda-matchers', require: false
  gem 'vcr', require: false
  gem 'webmock', require: false
end
