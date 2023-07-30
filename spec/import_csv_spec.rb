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

describe 'tests the import method' do
  def app
    Sinatra::Application
  end

  before(:each) do
    Rake.application.load_rakefile
    Rake::Task['drop_tables_if_exists'].execute
    Rake::Task['create_tables_if_not_exist'].execute
  end

  after(:all) do
    Rake::Task['drop_tables_if_exists'].execute
  end

  it 'inserts the csv in database successfully' do
    db = PG.connect(host: 'postgres-server-test', user: 'postgres')
    file = File.open('/app/data-3.csv')
    json = Insertions.read_and_parse_csv_to_json(file)
    Insertions.insert_csv_data(json)
    patients = db.exec('SELECT * FROM patients').to_a
    doctors = db.exec('SELECT * FROM doctors').to_a
    test_types = db.exec('SELECT * FROM test_types').to_a
    tests = db.exec('SELECT * FROM tests').to_a
    test_items = db.exec('SELECT * FROM test_items').to_a
    db.close
    expect(patients.length).to eq(12)
    expect(patients).to include(
      {
        'id' => '1',
        'name' => 'Emilly Batista Neto',
        'cpf' => '048.973.170-88',
        'email' => 'gerald.crona@ebert-quigley.com',
        'address' => '165 Rua Rafaela',
        'city' => 'Ituverava',
        'state' => 'Alagoas',
        'birthday' => '2001-03-11'
      },
      {
        'id' => '2',
        'name' => 'Juliana dos Reis Filho',
        'cpf' => '048.108.026-04',
        'email' => 'mariana_crist@kutch-torp.com',
        'address' => '527 Rodovia Júlio',
        'city' => 'Lagoa da Canoa',
        'state' => 'Paraíba',
        'birthday' => '1995-07-03'
      },
      {
        'id' => '3',
        'name' => 'Matheus Barroso',
        'cpf' => '066.126.400-90',
        'email' => 'maricela@streich.com',
        'address' => '9378 Rua Stella Braga',
        'city' => 'Senador Elói de Souza',
        'state' => 'Pernambuco',
        'birthday' => '1972-03-09'
      },
      {
        'id' => '4',
        'name' => 'Patricia Gentil',
        'cpf' => '089.034.562-70',
        'email' => 'herta_wehner@krajcik.name',
        'address' => '5334 Rodovia Thiago Bittencourt',
        'city' => 'Jequitibá',
        'state' => 'Paraná',
        'birthday' => '1998-02-25'
      },
      {
        'id' => '5',
        'name' => 'Ígor Moura',
        'cpf' => '077.411.587-40',
        'email' => 'edelmira.stanton@lowe-blick.io',
        'address' => '550 Rua Norberto',
        'city' => 'Anajatuba',
        'state' => 'Rio de Janeiro',
        'birthday' => '1991-02-27'
      },
      {
        'id' => '6',
        'name' => 'Vitor Hugo Gomes Neto',
        'cpf' => '019.338.696-82',
        'email' => 'leona@bahringer.net',
        'address' => 's/n Marginal Eloah Dantas',
        'city' => 'Serra Negra do Norte',
        'state' => 'Santa Catarina',
        'birthday' => '1978-01-26'
      },
      {
        'id' => '7',
        'name' => 'Giovanna Rêgo',
        'cpf' => '013.888.116-26',
        'email' => 'jefferson_renner@schulist.com',
        'address' => 's/n Marginal Júlia Paiva',
        'city' => 'Eliseu Martins',
        'state' => 'Roraima',
        'birthday' => '2000-04-16'
      },
      {
        'id' => '8',
        'name' => 'Sra. Meire da Terra',
        'cpf' => '052.041.078-51',
        'email' => 'lavinia@bartoletti.co',
        'address' => '230 Rua Eduarda',
        'city' => 'Rio Fortuna',
        'state' => 'Maranhão',
        'birthday' => '1968-06-21'
      },
      {
        'id' => '9',
        'name' => 'Liz Rios Neto',
        'cpf' => '073.372.599-64',
        'email' => 'bernarda_beer@emard.org',
        'address' => 's/n Viela Thiago da Cunha',
        'city' => 'Ibitiara',
        'state' => 'Rondônia',
        'birthday' => '1965-11-17'
      },
      {
        'id' => '10',
        'name' => 'Ladislau Duarte',
        'cpf' => '099.204.552-53',
        'email' => 'lisha@rosenbaum.org',
        'address' => 's/n Marginal Pietro',
        'city' => 'Peritiba',
        'state' => 'Rio Grande do Norte',
        'birthday' => '1981-02-02'
      },
      {
        'id' => '11',
        'name' => 'Valentina Cruz',
        'cpf' => '003.596.348-42',
        'email' => 'cortez.dickens@farrell.name',
        'address' => '644 Ponte Ryan Esteves',
        'city' => 'São José da Coroa Grande',
        'state' => 'Rondônia',
        'birthday' => '1979-04-04'
      },
      {
        'id' => '12',
        'name' => 'Antônio Rebouças',
        'cpf' => '071.488.453-78',
        'email' => 'adalberto_grady@feil.org',
        'address' => '25228 Travessa Ladislau',
        'city' => 'Tefé',
        'state' => 'Sergipe',
        'birthday' => '1999-04-11'
      }
    )
    expect(doctors).to include(
      {
        'id' => '1',
        'name' => 'Maria Luiza Pires',
        'crm' => 'B000BJ20J4',
        'crm_state' => 'PI',
        'email' => 'denna@wisozk.biz'
      },
      {
        'id' => '2',
        'name' => 'Maria Helena Ramalho',
        'crm' => 'B0002IQM66',
        'crm_state' => 'SC',
        'email' => 'rayford@kemmer-kunze.info'
      },
      {
        'id' => '3',
        'name' => 'Sra. Calebe Louzada',
        'crm' => 'B000B7CDX4',
        'crm_state' => 'SP',
        'email' => 'kendra@nolan-sawayn.co'
      },
      {
        'id' => '4',
        'name' => 'Dra. Isabelly Rêgo',
        'crm' => 'B0002W2RBG',
        'crm_state' => 'CE',
        'email' => 'diann_klein@schinner.org'
      },
      {
        'id' => '5',
        'name' => 'Núbia Godins',
        'crm' => 'B000HB2O2O',
        'crm_state' => 'ES',
        'email' => 'christy_dickinson@langworth.org'
      },
      {
        'id' => '6',
        'name' => 'Ana Sophia Aparício Neto',
        'crm' => 'B000BJ8TIA',
        'crm_state' => 'PR',
        'email' => 'corene.hane@pagac.io'
      }
    )
    expect(test_types).to include(
      {
        'id' => '1',
        'name' => 'hemácias',
        'limits' => '45-52'
      },
      {
        'id' => '2',
        'name' => 'ldl',
        'limits' => '45-54'
      },
      {
        'id' => '3',
        'name' => 'ácido úrico',
        'limits' => '15-61'
      },
      {
        'id' => '4',
        'name' => 't4-livre',
        'limits' => '34-60'
      },
      {
        'id' => '5',
        'name' => 'plaquetas',
        'limits' => '11-93'
      },
      {
        'id' => '6',
        'name' => 'eletrólitos',
        'limits' => '2-68'
      },
      {
        'id' => '7',
        'name' => 'tsh',
        'limits' => '25-80'
      }
    )
    expect(tests).to include(
      {
        'id' => '1',
        'token' => 'IQCZ17',
        'date' => '2021-08-05',
        'patient_id' => '1',
        'doctor_id' => '1'
      },
      {
        'id' => '2',
        'token' => '0W9I67',
        'date' => '2021-07-09',
        'patient_id' => '2',
        'doctor_id' => '2'
      },
      {
        'id' => '3',
        'token' => 'T9O6AI',
        'date' => '2021-11-21',
        'patient_id' => '3',
        'doctor_id' => '3'
      },
      {
        'id' => '4',
        'token' => 'TJUXC2',
        'date' => '2021-10-05',
        'patient_id' => '4',
        'doctor_id' => '4'
      },
      {
        'id' => '5',
        'token' => '2VPICQ',
        'date' => '2021-04-23',
        'patient_id' => '5',
        'doctor_id' => '1'
      },
      {
        'id' => '6',
        'token' => 'Z95COQ',
        'date' => '2021-04-29',
        'patient_id' => '6',
        'doctor_id' => '4'
      },
      {
        'id' => '7',
        'token' => 'F6SPTX',
        'date' => '2021-10-29',
        'patient_id' => '7',
        'doctor_id' => '4'
      },
      {
        'id' => '8',
        'token' => 'NIG0TP',
        'date' => '2022-01-08',
        'patient_id' => '8',
        'doctor_id' => '2'
      },
      {
        'id' => '9',
        'token' => '0DJ575',
        'date' => '2021-12-29',
        'patient_id' => '9',
        'doctor_id' => '5'
      },
      {
        'id' => '10',
        'token' => '00S0MD',
        'date' => '2022-03-03',
        'patient_id' => '10',
        'doctor_id' => '6'
      },
      {
        'id' => '11',
        'token' => 'L13HPF',
        'date' => '2021-04-27',
        'patient_id' => '11',
        'doctor_id' => '3'
      },
      {
        'id' => '12',
        'token' => 'AIWH8Y',
        'date' => '2021-06-29',
        'patient_id' => '12',
        'doctor_id' => '4'
      }
    )
    expect(test_items).to include(
      {
        'id' => '1',
        'result' => '97',
        'test_id' => '1',
        'test_type_id' => '1'
      },
      {
        'id' => '2',
        'result' => '66',
        'test_id' => '2',
        'test_type_id' => '2'
      },
      {
        'id' => '3',
        'result' => '78',
        'test_id' => '2',
        'test_type_id' => '3'
      },
      {
        'id' => '4',
        'result' => '95',
        'test_id' => '3',
        'test_type_id' => '4'
      },
      {
        'id' => '5',
        'result' => '10',
        'test_id' => '3',
        'test_type_id' => '3'
      },
      {
        'id' => '6',
        'result' => '94',
        'test_id' => '4',
        'test_type_id' => '3'
      },
      {
        'id' => '7',
        'result' => '84',
        'test_id' => '5',
        'test_type_id' => '2'
      },
      {
        'id' => '8',
        'result' => '52',
        'test_id' => '6',
        'test_type_id' => '3'
      },
      {
        'id' => '9',
        'result' => '1',
        'test_id' => '7',
        'test_type_id' => '1'
      },
      {
        'id' => '10',
        'result' => '38',
        'test_id' => '8',
        'test_type_id' => '5'
      },
      {
        'id' => '11',
        'result' => '4',
        'test_id' => '9',
        'test_type_id' => '3'
      },
      {
        'id' => '12',
        'result' => '3',
        'test_id' => '10',
        'test_type_id' => '3'
      },
      {
        'id' => '13',
        'result' => '27',
        'test_id' => '11',
        'test_type_id' => '6'
      },
      {
        'id' => '14',
        'result' => '89',
        'test_id' => '11',
        'test_type_id' => '7'
      },
      {
        'id' => '15',
        'result' => '6',
        'test_id' => '12',
        'test_type_id' => '1'
      }
    )
  end

  it 'read and parse to json sucessefuly' do    
    file = File.open('/app/data-3.csv')
    json = Insertions.read_and_parse_csv_to_json(file)
    expect(json.length).to eq 15
    expect(json).to include(
      {
        'cpf' => '048.973.170-88',
        'nome paciente' => 'Emilly Batista Neto',
        'email paciente' => 'gerald.crona@ebert-quigley.com',
        'data nascimento paciente' => '2001-03-11',
        'endereço/rua paciente' => '165 Rua Rafaela',
        'cidade paciente' => 'Ituverava',
        'estado patiente' => 'Alagoas',
        'crm médico' => 'B000BJ20J4',
        'crm médico estado' => 'PI',
        'nome médico' => 'Maria Luiza Pires',
        'email médico' => 'denna@wisozk.biz',
        'token resultado exame' => 'IQCZ17',
        'data exame' => '2021-08-05',
        'tipo exame' => 'hemácias',
        'limites tipo exame' => '45-52',
        'resultado tipo exame' => '97'
      },
      {
        'cpf' => '048.108.026-04',
        'nome paciente' => 'Juliana dos Reis Filho',
        'email paciente' => 'mariana_crist@kutch-torp.com',
        'data nascimento paciente' => '1995-07-03',
        'endereço/rua paciente' => '527 Rodovia Júlio',
        'cidade paciente' => 'Lagoa da Canoa',
        'estado patiente' => 'Paraíba',
        'crm médico' => 'B0002IQM66',
        'crm médico estado' => 'SC',
        'nome médico' => 'Maria Helena Ramalho',
        'email médico' => 'rayford@kemmer-kunze.info',
        'token resultado exame' => '0W9I67',
        'data exame' => '2021-07-09',
        'tipo exame' => 'ldl',
        'limites tipo exame' => '45-54',
        'resultado tipo exame' => '66'
      },
      {
        'cpf' => '048.108.026-04',
        'nome paciente' => 'Juliana dos Reis Filho',
        'email paciente' => 'mariana_crist@kutch-torp.com',
        'data nascimento paciente' => '1995-07-03',
        'endereço/rua paciente' => '527 Rodovia Júlio',
        'cidade paciente' => 'Lagoa da Canoa',
        'estado patiente' => 'Paraíba',
        'crm médico' => 'B0002IQM66',
        'crm médico estado' => 'SC',
        'nome médico' => 'Maria Helena Ramalho',
        'email médico' => 'rayford@kemmer-kunze.info',
        'token resultado exame' => '0W9I67',
        'data exame' => '2021-07-09',
        'tipo exame' => 'ácido úrico',
        'limites tipo exame' => '15-61',
        'resultado tipo exame' => '78'
      },
      {
        'cpf' => '066.126.400-90',
        'nome paciente' => 'Matheus Barroso',
        'email paciente' => 'maricela@streich.com',
        'data nascimento paciente' => '1972-03-09',
        'endereço/rua paciente' => '9378 Rua Stella Braga',
        'cidade paciente' => 'Senador Elói de Souza',
        'estado patiente' => 'Pernambuco',
        'crm médico' => 'B000B7CDX4',
        'crm médico estado' => 'SP',
        'nome médico' => 'Sra. Calebe Louzada',
        'email médico' => 'kendra@nolan-sawayn.co',
        'token resultado exame' => 'T9O6AI',
        'data exame' => '2021-11-21',
        'tipo exame' => 't4-livre',
        'limites tipo exame' => '34-60',
        'resultado tipo exame' => '95'
      },
      {
        'cpf' => '066.126.400-90',
        'nome paciente' => 'Matheus Barroso',
        'email paciente' => 'maricela@streich.com',
        'data nascimento paciente' => '1972-03-09',
        'endereço/rua paciente' => '9378 Rua Stella Braga',
        'cidade paciente' => 'Senador Elói de Souza',
        'estado patiente' => 'Pernambuco',
        'crm médico' => 'B000B7CDX4',
        'crm médico estado' => 'SP',
        'nome médico' => 'Sra. Calebe Louzada',
        'email médico' => 'kendra@nolan-sawayn.co',
        'token resultado exame' => 'T9O6AI',
        'data exame' => '2021-11-21',
        'tipo exame' => 'ácido úrico',
        'limites tipo exame' => '15-61',
        'resultado tipo exame' => '10'
      },
      {
        'cpf' => '089.034.562-70',
        'nome paciente' => 'Patricia Gentil',
        'email paciente' => 'herta_wehner@krajcik.name',
        'data nascimento paciente' => '1998-02-25',
        'endereço/rua paciente' => '5334 Rodovia Thiago Bittencourt',
        'cidade paciente' => 'Jequitibá',
        'estado patiente' => 'Paraná',
        'crm médico' => 'B0002W2RBG',
        'crm médico estado' => 'CE',
        'nome médico' => 'Dra. Isabelly Rêgo',
        'email médico' => 'diann_klein@schinner.org',
        'token resultado exame' => 'TJUXC2',
        'data exame' => '2021-10-05',
        'tipo exame' => 'ácido úrico',
        'limites tipo exame' => '15-61',
        'resultado tipo exame' => '94'
      },
      {
        'cpf' => '077.411.587-40',
        'nome paciente' => 'Ígor Moura',
        'email paciente' => 'edelmira.stanton@lowe-blick.io',
        'data nascimento paciente' => '1991-02-27',
        'endereço/rua paciente' => '550 Rua Norberto',
        'cidade paciente' => 'Anajatuba',
        'estado patiente' => 'Rio de Janeiro',
        'crm médico' => 'B000BJ20J4',
        'crm médico estado' => 'PI',
        'nome médico' => 'Maria Luiza Pires',
        'email médico' => 'denna@wisozk.biz',
        'token resultado exame' => '2VPICQ',
        'data exame' => '2021-04-23',
        'tipo exame' => 'ldl',
        'limites tipo exame' => '45-54',
        'resultado tipo exame' => '84'
      },
      {
        'cpf' => '019.338.696-82',
        'nome paciente' => 'Vitor Hugo Gomes Neto',
        'email paciente' => 'leona@bahringer.net',
        'data nascimento paciente' => '1978-01-26',
        'endereço/rua paciente' => 's/n Marginal Eloah Dantas',
        'cidade paciente' => 'Serra Negra do Norte',
        'estado patiente' => 'Santa Catarina',
        'crm médico' => 'B0002W2RBG',
        'crm médico estado' => 'CE',
        'nome médico' => 'Dra. Isabelly Rêgo',
        'email médico' => 'diann_klein@schinner.org',
        'token resultado exame' => 'Z95COQ',
        'data exame' => '2021-04-29',
        'tipo exame' => 'ácido úrico',
        'limites tipo exame' => '15-61',
        'resultado tipo exame' => '52'
      },
      {
        'cpf' => '013.888.116-26',
        'nome paciente' => 'Giovanna Rêgo',
        'email paciente' => 'jefferson_renner@schulist.com',
        'data nascimento paciente' => '2000-04-16',
        'endereço/rua paciente' => 's/n Marginal Júlia Paiva',
        'cidade paciente' => 'Eliseu Martins',
        'estado patiente' => 'Roraima',
        'crm médico' => 'B0002W2RBG',
        'crm médico estado' => 'SP',
        'nome médico' => 'Dra. Isabelly Rêgo',
        'email médico' => 'diann_klein@schinner.org',
        'token resultado exame' => 'F6SPTX',
        'data exame' => '2021-10-29',
        'tipo exame' => 'hemácias',
        'limites tipo exame' => '45-52',
        'resultado tipo exame' => '1'
      },
      {
        'cpf' => '052.041.078-51',
        'nome paciente' => 'Sra. Meire da Terra',
        'email paciente' => 'lavinia@bartoletti.co',
        'data nascimento paciente' => '1968-06-21',
        'endereço/rua paciente' => '230 Rua Eduarda',
        'cidade paciente' => 'Rio Fortuna',
        'estado patiente' => 'Maranhão',
        'crm médico' => 'B0002IQM66',
        'crm médico estado' => 'SC',
        'nome médico' => 'Maria Helena Ramalho',
        'email médico' => 'rayford@kemmer-kunze.info',
        'token resultado exame' => 'NIG0TP',
        'data exame' => '2022-01-08',
        'tipo exame' => 'plaquetas',
        'limites tipo exame' => '11-93',
        'resultado tipo exame' => '38'
      },
      {
        'cpf' => '073.372.599-64',
        'nome paciente' => 'Liz Rios Neto',
        'email paciente' => 'bernarda_beer@emard.org',
        'data nascimento paciente' => '1965-11-17',
        'endereço/rua paciente' => 's/n Viela Thiago da Cunha',
        'cidade paciente' => 'Ibitiara',
        'estado patiente' => 'Rondônia',
        'crm médico' => 'B000HB2O2O',
        'crm médico estado' => 'ES',
        'nome médico' => 'Núbia Godins',
        'email médico' => 'christy_dickinson@langworth.org',
        'token resultado exame' => '0DJ575',
        'data exame' => '2021-12-29',
        'tipo exame' => 'ácido úrico',
        'limites tipo exame' => '15-61',
        'resultado tipo exame' => '4'
      },
      {
        'cpf' => '099.204.552-53',
        'nome paciente' => 'Ladislau Duarte',
        'email paciente' => 'lisha@rosenbaum.org',
        'data nascimento paciente' => '1981-02-02',
        'endereço/rua paciente' => 's/n Marginal Pietro',
        'cidade paciente' => 'Peritiba',
        'estado patiente' => 'Rio Grande do Norte',
        'crm médico' => 'B000BJ8TIA',
        'crm médico estado' => 'PR',
        'nome médico' => 'Ana Sophia Aparício Neto',
        'email médico' => 'corene.hane@pagac.io',
        'token resultado exame' => '00S0MD',
        'data exame' => '2022-03-03',
        'tipo exame' => 'ácido úrico',
        'limites tipo exame' => '15-61',
        'resultado tipo exame' => '3'
      },
      {
        'cpf' => '003.596.348-42',
        'nome paciente' => 'Valentina Cruz',
        'email paciente' => 'cortez.dickens@farrell.name',
        'data nascimento paciente' => '1979-04-04',
        'endereço/rua paciente' => '644 Ponte Ryan Esteves',
        'cidade paciente' => 'São José da Coroa Grande',
        'estado patiente' => 'Rondônia',
        'crm médico' => 'B000B7CDX4',
        'crm médico estado' => 'SP',
        'nome médico' => 'Sra. Calebe Louzada',
        'email médico' => 'kendra@nolan-sawayn.co',
        'token resultado exame' => 'L13HPF',
        'data exame' => '2021-04-27',
        'tipo exame' => 'eletrólitos',
        'limites tipo exame' => '2-68',
        'resultado tipo exame' => '27'
      },
      {
        'cpf' => '003.596.348-42',
        'nome paciente' => 'Valentina Cruz',
        'email paciente' => 'cortez.dickens@farrell.name',
        'data nascimento paciente' => '1979-04-04',
        'endereço/rua paciente' => '644 Ponte Ryan Esteves',
        'cidade paciente' => 'São José da Coroa Grande',
        'estado patiente' => 'Rondônia',
        'crm médico' => 'B000B7CDX4',
        'crm médico estado' => 'SP',
        'nome médico' => 'Sra. Calebe Louzada',
        'email médico' => 'kendra@nolan-sawayn.co',
        'token resultado exame' => 'L13HPF',
        'data exame' => '2021-04-27',
        'tipo exame' => 'tsh',
        'limites tipo exame' => '25-80',
        'resultado tipo exame' => '89'
      },
      {
        'cpf' => '071.488.453-78',
        'nome paciente' => 'Antônio Rebouças',
        'email paciente' => 'adalberto_grady@feil.org',
        'data nascimento paciente' => '1999-04-11',
        'endereço/rua paciente' => '25228 Travessa Ladislau',
        'cidade paciente' => 'Tefé',
        'estado patiente' => 'Sergipe',
        'crm médico' => 'B0002W2RBG',
        'crm médico estado' => 'SP',
        'nome médico' => 'Dra. Isabelly Rêgo',
        'email médico' => 'diann_klein@schinner.org',
        'token resultado exame' => 'AIWH8Y',
        'data exame' => '2021-06-29',
        'tipo exame' => 'hemácias',
        'limites tipo exame' => '45-52',
        'resultado tipo exame' => '6'
      }
   )
  end
end
