# frozen_string_literal: true

redis_url = ENV['REDIS_URL']
$redis = Redis.new(url: redis_url)
RailsPangu::Application.config.session_store :redis_store, servers: redis_url, domain: '*'
