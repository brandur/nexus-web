require "bundler/setup"
Bundler.require

# so logging output appears properly
$stdout.sync = true

configure do
  set :show_exceptions, false
end

# Sinatra app
require "./web"

Slim::Engine.set_default_options format: :html5, pretty: true

map "/assets" do
  assets = Sprockets::Environment.new do |env|
    env.append_path(settings.root + "/assets/javascripts")
    env.append_path(settings.root + "/assets/stylesheets")
    env.logger = Logger.new($stdout)
  end
  run assets
end

map "/" do
  use Rack::SSL if ENV["FORCE_SSL"]
  use Rack::Instruments
  run Sinatra::Application
end
