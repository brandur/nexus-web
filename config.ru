require "bundler/setup"
Bundler.require

# so logging output appears properly
$stdout.sync = true

configure do
  set :show_exceptions, false
end

# Sinatra app
require "./web"

map "/" do
  use Rack::SSL if ENV["FORCE_SSL"]
  use Rack::Instruments
  run Sinatra::Application
end
