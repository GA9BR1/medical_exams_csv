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

describe 'test, get requests' do
  def app
    Sinatra::Application
  end

  before(:all) do
    Rake.application.load_rakefile
    Rake::Task['drop_tables_if_exists'].execute
    Rake::Task['create_tables_if_not_exist'].execute
    db = PG.connect(host: 'postgres-server-test', user: 'postgres')
    file = File.open('/app/data-3.csv')
    json = Insertions.read_and_parse_csv_to_json(file)
    Insertions.insert_csv_data(json)
    db.close
  end

  after(:all) do
    Rake::Task['drop_tables_if_exists'].execute
  end

  it '/tests/:id' do
    get '/tests/0W9I67'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq(
      {
        'result_token' => '0W9I67',
        'result_date' => '2021-07-09',
        'cpf' => '048.108.026-04',
        'name' => 'Juliana dos Reis Filho',
        'email' => 'mariana_crist@kutch-torp.com',
        'birthday' => '1995-07-03',
        'doctor' => {
          'crm' => 'B0002IQM66',
          'crm_state' => 'SC',
          'name' => 'Maria Helena Ramalho'
        },
        'tests' => [
          {
            'type' => 'ácido úrico',
            'limits' => '15-61',
            'result' => 78
          },
          {
            'type' => 'ldl',
            'limits' => '45-54',
            'result' => 66
          }
        ]
      }
    )
  end

  it '/tests sucessfully' do
    get '/tests'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq(
      [
        {
          'result_token' => '00S0MD',
          'result_date' => '2022-03-03',
          'cpf' => '099.204.552-53',
          'name' => 'Ladislau Duarte',
          'email' => 'lisha@rosenbaum.org',
          'birthday' => '1981-02-02',
          'doctor' => {
            'crm' => 'B000BJ8TIA',
            'crm_state' => 'PR',
            'name' => 'Ana Sophia Aparício Neto'
          },
          'tests' => [
            {
              'type' => 'ácido úrico',
              'limits' => '15-61',
              'result' => 3
            }
          ]
        },
        {
          'result_token' => 'NIG0TP',
          'result_date' => '2022-01-08',
          'cpf' => '052.041.078-51',
          'name' => 'Sra. Meire da Terra',
          'email' => 'lavinia@bartoletti.co',
          'birthday' => '1968-06-21',
          'doctor' => {
            'crm' => 'B0002IQM66',
            'crm_state' => 'SC',
            'name' => 'Maria Helena Ramalho'
          },
          'tests' => [
            {
              'type' => 'plaquetas',
              'limits' => '11-93',
              'result' => 38
            }
          ]
        },
        {
          'result_token' => '0DJ575',
          'result_date' => '2021-12-29',
          'cpf' => '073.372.599-64',
          'name' => 'Liz Rios Neto',
          'email' => 'bernarda_beer@emard.org',
          'birthday' => '1965-11-17',
          'doctor' => {
            'crm' => 'B000HB2O2O',
            'crm_state' => 'ES',
            'name' => 'Núbia Godins'
          },
          'tests' => [
            {
              'type' => 'ácido úrico',
              'limits' => '15-61',
              'result' => 4
            }
          ]
        },
        {
          'result_token' => 'T9O6AI',
          'result_date' => '2021-11-21',
          'cpf' => '066.126.400-90',
          'name' => 'Matheus Barroso',
          'email' => 'maricela@streich.com',
          'birthday' => '1972-03-09',
          'doctor' => {
            'crm' => 'B000B7CDX4',
            'crm_state' => 'SP',
            'name' => 'Sra. Calebe Louzada'
          },
          'tests' => [
            {
              'type' => 'ácido úrico',
              'limits' => '15-61',
              'result' => 10
            },
            {
              'type' => 't4-livre',
              'limits' => '34-60',
              'result' => 95
            }
          ]
        },
        {
          'result_token' => 'F6SPTX',
          'result_date' => '2021-10-29',
          'cpf' => '013.888.116-26',
          'name' => 'Giovanna Rêgo',
          'email' => 'jefferson_renner@schulist.com',
          'birthday' => '2000-04-16',
          'doctor' => {
            'crm' => 'B0002W2RBG',
            'crm_state' => 'CE',
            'name' => 'Dra. Isabelly Rêgo'
          },
          'tests' => [
            {
              'type' => 'hemácias',
              'limits' => '45-52',
              'result' => 1
            }
          ]
        },
        {
          'result_token' => 'TJUXC2',
          'result_date' => '2021-10-05',
          'cpf' => '089.034.562-70',
          'name' => 'Patricia Gentil',
          'email' => 'herta_wehner@krajcik.name',
          'birthday' => '1998-02-25',
          'doctor' => {
            'crm' => 'B0002W2RBG',
            'crm_state' => 'CE',
            'name' => 'Dra. Isabelly Rêgo'
          },
          'tests' => [
            {
              'type' => 'ácido úrico',
              'limits' => '15-61',
              'result' => 94
            }
          ]
        },
        {
          'result_token' => 'IQCZ17',
          'result_date' => '2021-08-05',
          'cpf' => '048.973.170-88',
          'name' => 'Emilly Batista Neto',
          'email' => 'gerald.crona@ebert-quigley.com',
          'birthday' => '2001-03-11',
          'doctor' => {
            'crm' => 'B000BJ20J4',
            'crm_state' => 'PI',
            'name' => 'Maria Luiza Pires'
          },
          'tests' => [
            {
              'type' => 'hemácias',
              'limits' => '45-52',
              'result' => 97
            }
          ]
        },
        {
          'result_token' => '0W9I67',
          'result_date' => '2021-07-09',
          'cpf' => '048.108.026-04',
          'name' => 'Juliana dos Reis Filho',
          'email' => 'mariana_crist@kutch-torp.com',
          'birthday' => '1995-07-03',
          'doctor' => {
            'crm' => 'B0002IQM66',
            'crm_state' => 'SC',
            'name' => 'Maria Helena Ramalho'
          },
          'tests' => [
            {
              'type' => 'ldl',
              'limits' => '45-54',
              'result' => 66
            },
            {
              'type' => 'ácido úrico',
              'limits' => '15-61',
              'result' => 78
            }
          ]
        },
        {
          'result_token' => 'AIWH8Y',
          'result_date' => '2021-06-29',
          'cpf' => '071.488.453-78',
          'name' => 'Antônio Rebouças',
          'email' => 'adalberto_grady@feil.org',
          'birthday' => '1999-04-11',
          'doctor' => {
            'crm' => 'B0002W2RBG',
            'crm_state' => 'CE',
            'name' => 'Dra. Isabelly Rêgo'
          },
          'tests' => [
            {
              'type' => 'hemácias',
              'limits' => '45-52',
              'result' => 6
            }
          ]
        },
        {
          'result_token' => 'Z95COQ',
          'result_date' => '2021-04-29',
          'cpf' => '019.338.696-82',
          'name' => 'Vitor Hugo Gomes Neto',
          'email' => 'leona@bahringer.net',
          'birthday' => '1978-01-26',
          'doctor' => {
            'crm' => 'B0002W2RBG',
            'crm_state' => 'CE',
            'name' => 'Dra. Isabelly Rêgo'
          },
          'tests' => [
            {
              'type' => 'ácido úrico',
              'limits' => '15-61',
              'result' => 52
            }
          ]
        },
        {
          'result_token' => 'L13HPF',
          'result_date' => '2021-04-27',
          'cpf' => '003.596.348-42',
          'name' => 'Valentina Cruz',
          'email' => 'cortez.dickens@farrell.name',
          'birthday' => '1979-04-04',
          'doctor' => {
            'crm' => 'B000B7CDX4',
            'crm_state' => 'SP',
            'name' => 'Sra. Calebe Louzada'
          },
          'tests' => [
            {
              'type' => 'tsh',
              'limits' => '25-80',
              'result' => 89
            },
            {
              'type' => 'eletrólitos',
              'limits' => '2-68',
              'result' => 27
            }
          ]
        },
        {
          'result_token' => '2VPICQ',
          'result_date' => '2021-04-23',
          'cpf' => '077.411.587-40',
          'name' => 'Ígor Moura',
          'email' => 'edelmira.stanton@lowe-blick.io',
          'birthday' => '1991-02-27',
          'doctor' => {
            'crm' => 'B000BJ20J4',
            'crm_state' => 'PI',
            'name' => 'Maria Luiza Pires'
          },
          'tests' => [
            {
              'type' => 'ldl',
              'limits' => '45-54',
              'result' => 84
            }
          ]
        }
      ]
    )
  end
end