require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative 'insertions'


get '/tests' do
  Insertions.insert
  db = PG.connect(host: 'postgres-server', user: 'postgres')
  data = db.exec("SELECT
    t.token AS result_token,
    t.date AS result_date, 
    p.cpf, 
    p.name, 
    p.email, 
    p.birthday,
    json_build_object(
      'crm', d.crm,
      'crm_state', d.crm_state,
      'name', d.name
                     ) AS doctor,
      json_build_object(
        'type', tt.name,
        'limits', tt.limits,
        'result', ti.result
      ) AS tests
    FROM tests AS t
    JOIN patients p ON t.patient_id = p.id
    JOIN doctors d ON t.doctor_id = d.id
    JOIN test_items ti ON ti.test_id = t.id
    JOIN test_types tt ON ti.test_type_id = tt.id
    GROUP BY t.id, t.date, p.cpf, p.name, p.email, p.birthday, d.crm, d.crm_state, d.name, tt.name, tt.limits, ti.id
  ").to_a

  data = data.map do |row|
    {
      'result_token' => row['result_token'],
      'result_date' => row['result_date'],
      'cpf' => row['cpf'],
      'name' => row['name'],
      'email' => row['email'],
      'birthday' => row['birthday'],
      'doctor' => JSON.parse(row['doctor']),
      'tests' => JSON.parse(row['tests'])
    }
  end

  grouped_data = []
  data.each do |record|
    token = record['result_token']
    found_index = nil
    grouped_data.each_with_index do |item, index|
      if item['result_token'] == token
        found_index = index
        break
      end
    end
    if found_index
      grouped_data[found_index]['tests'] << {
        'type' => record['tests']['type'],
        'limits' => record['tests']['limits'],
        'result' => record['tests']['result']
      }
    else 
      grouped_data << {
      'result_token' => token,
      'result_date' => record['result_date'],
      'cpf' => record['cpf'],
      'name' => record['name'],
      'email' => record['email'],
      'birthday' => record['birthday'],
      'doctor' => record['doctor'],
      'tests' => [{
        'type' => record['tests']['type'],
        'limits' => record['tests']['limits'],
        'result' => record['tests']['result']
      }]
    }
    end
  end


  JSON.pretty_generate(grouped_data)
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)