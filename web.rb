#
# Error handling
#

error do
  log :error, type: env['sinatra.error'].class.name,
    message: env['sinatra.error'].message,
    backtrace: env['sinatra.error'].backtrace
  [500, { message: "Internal server error" }.to_json]
end

#
# Public
#

get "/" do
  slim :index
end
