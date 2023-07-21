require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'insertions'
require_relative 'query_and_format'

get '/tests' do
  Insertions.insert_csv_data
  QueryAndFormat.get_all_tests
end

get '/' do
  "Hello World"
end
 
get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)