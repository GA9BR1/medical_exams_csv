require 'sinatra'
require 'rack/handler/puma'
require 'logger'

configure do
  set :logging, Logger::DEBUG
end

get '/' do
  File.open('index.html')
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 4000,
  Host: '0.0.0.0'
)