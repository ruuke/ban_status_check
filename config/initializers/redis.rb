if Rails.env.test?
  require 'fakeredis'
  $redis = Redis.new
else
  $redis = Redis.new(url: "redis://localhost:6379")
end
