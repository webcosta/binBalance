require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BinBal
  class Application < Rails::Application
    config.load_defaults 5.2

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'app.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    
    config.active_job.queue_adapter = :sidekiq
  end
end
