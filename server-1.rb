require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require 'logger'
require_relative 'insertions'
require_relative 'query_and_format'
require 'rack/cors'
require_relative 'worker'
require 'sidekiq'
require 'active_support/time'
require 'redis'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post]
  end
end

configure do
  set :logging, Logger::DEBUG
end

get '/tests' do
  QueryAndFormat.get_all_tests
end

get '/tests/:token' do
  QueryAndFormat.get_single_test(params[:token])
end

post '/import' do
  file = params[:csvFile]
  begin
    json_csv = Insertions.read_and_parse_csv_to_json(file['tempfile'])
    job_id = Worker.perform_async(json_csv, file['filename'])
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Methods' => 'POST', 'Access-Control-Allow-Headers' => 'Content-Type'
    body job_id
    status 200
  rescue => e
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Methods' => 'POST', 'Access-Control-Allow-Headers' => 'Content-Type'
    status 400
    body "Erro ao processar o arquivo: #{e.message}"
  end
end

post '/status' do
  job_ids = JSON.parse(request.body.read)
  jobs_status = []
  job_ids.each do |job_id|
    jobs_status << Worker.get_job_status(job_id)
  end
  JSON.pretty_generate(jobs_status)
end

if ENV['APP_ENV'] != 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end