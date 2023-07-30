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

  it '/status sucessfuly' do
    csv = File.open('/app/data.csv')
    json_csv_1 = Insertions.read_and_parse_csv_to_json(csv)
    csv2 = File.open('/app/data-2.csv')
    json_csv_2 = Insertions.read_and_parse_csv_to_json(csv2)
    jb1 = Worker.perform_async(json_csv_1, File.basename(csv.path))
    jb2 = Worker.perform_async(json_csv_2, File.basename(csv2.path))


    timeout = 7
    start_time = Time.now
    status = nil
    loop do
      status = Worker.get_job_status(jb1)
      status = JSON.parse(status)[0] if status 

      break if status == 'Completed' || (timeout && Time.now - start_time > timeout)

      sleep 0.1
    end

    timeout = 7
    start_time = Time.now
    status = nil
    loop do
      status = Worker.get_job_status(jb2)
      status = JSON.parse(status)[0] if status

      break if status == 'Completed' || (timeout && Time.now - start_time > timeout)

      sleep 0.1
    end

    data = [jb1.to_s, jb2.to_s].to_json

    post '/status', data, 'CONTENT_TYPE' => 'application/json'
    response_array = JSON.parse(last_response.body)
    expect(response_array.length).to eq(2)
    expect(response_array[0]).to eq(Worker.get_job_status(jb1))
    expect(response_array[1]).to eq(Worker.get_job_status(jb2))
  end
end
