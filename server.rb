require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require 'logger'
require_relative 'insertions'
require_relative 'query_and_format'

configure do
  set :logging, Logger::DEBUG
end


before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers' => 'Content-Type'
end

get '/tests' do
  QueryAndFormat.get_all_tests
end

get '/' do
  File.open('index.html')
end

post '/import' do
  file = params[:csvFile][:tempfile]
  Insertions.insert_csv_data(file)
end
 
get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)