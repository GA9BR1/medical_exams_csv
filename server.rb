require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'insertions'


get '/tests' do
  Insertions.insert
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)