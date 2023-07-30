ENV['APP_ENV'] = 'test'

require_relative '../server-1'
require_relative 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'
require 'rake'
require_relative '../rakefile'
require_relative '../insertions'
require 'pg'
require_relative '../query_and_format'
require 'rspec/eventually'
require_relative '../worker'
require 'json'

describe 'test, post requests' do
  def app
    Sinatra::Application
  end

  before(:all) do
    Rake.application.load_rakefile
    Rake::Task['drop_tables_if_exists'].execute
    Rake::Task['create_tables_if_not_exist'].execute
  end

  after(:all) do
    Rake::Task['drop_tables_if_exists'].execute
  end

  it '/import sucessfuly' do
    csv = File.open('/app/data.csv')
    post '/import', { csvFile: Rack::Test::UploadedFile.new(csv, 'text/csv') }
    expect(last_response.status).to eq(200)

    timeout = 7
    start_time = Time.now
    status = nil
    loop do
      status = Worker.get_job_status(last_response.body)
      status = JSON.parse(status)[0] if status

      break if status == 'Working' || (timeout && Time.now - start_time > timeout)

      sleep 0.1
    end
    expect(status).to eq('Working')

    timeout = 7
    start_time = Time.now
    status = nil
    loop do
      status = Worker.get_job_status(last_response.body)
      status = JSON.parse(status)[0] if status 

      break if status == 'Completed' || (timeout && Time.now - start_time > timeout)

      sleep 0.1
    end
    expect(status).to eq('Completed')
  end

  it '/import with error' do
    csv = File.open('/app/teste.csv')
    post '/import', { csvFile: Rack::Test::UploadedFile.new(csv, 'text/csv') }
    expect(last_response.status).to eq(400)
    expect(last_response.body).to include('Erro ao processar o arquivo')
  end
end
