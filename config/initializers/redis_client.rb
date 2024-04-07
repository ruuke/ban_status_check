# frozen_string_literal: true

module RedisClient
  def self.client
    @client ||= if Rails.env.test?
                  require 'fakeredis'
                  Redis.new
                else
                  Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379')
                end
  end
end
