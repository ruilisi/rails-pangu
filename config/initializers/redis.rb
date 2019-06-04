redis_url = ENV['REDIS_URL']
$redis = Redis.new(url: redis_url)
RailsDeviseJWT::Application.config.session_store :redis_store, servers: redis_url, domain: '*'
