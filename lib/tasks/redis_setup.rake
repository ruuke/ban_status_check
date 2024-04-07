# frozen_string_literal: true

namespace :redis_setup do
  desc 'Populate Redis with whitelisted countries'
  task populate_whitelist: :environment do
    whitelisted_countries = %w[US CA GB]
    whitelisted_countries.each do |country_code|
      $redis.sadd('whitelisted_countries', country_code)
    end
    puts 'Whitelisted countries populated in Redis.'
  end
end
