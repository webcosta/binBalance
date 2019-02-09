Sidekiq::Extensions.enable_delay!

Sidekiq.configure_server do |confog|
    confog.redis = { url: 'redis://localhost:6379/binance_queue'}
end

Sidekiq.configure_client do |confog|
    confog.redis = { url: 'redis://localhost:6379/binance_queue'}
end