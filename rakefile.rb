require 'pg'
require 'rake'

task :create_tables_if_not_exist do
  if ENV['APP_ENV'] != 'test'
    db = PG.connect(host: 'postgres-server', user: 'postgres')
  else
    db = PG.connect(host: 'postgres-server-test', user: 'postgres')
  end
  db.exec('SET client_min_messages TO WARNING;')
  db.exec('CREATE TABLE IF NOT EXISTS doctors (
          id SERIAL PRIMARY KEY NOT NULL,
          name VARCHAR NOT NULL,
          crm VARCHAR NOT NULL,
          crm_state VARCHAR NOT NULL,
          email VARCHAR NOT NULL,
          CONSTRAINT unique_doctor_crm UNIQUE (crm)
          );')
  db.exec('CREATE TABLE IF NOT EXISTS test_types (
          id SERIAL PRIMARY KEY NOT NULL,
          name VARCHAR NOT NULL,
          limits VARCHAR NOT NULL,
          CONSTRAINT unique_test_type_name UNIQUE (name)
          );')
  db.exec('CREATE TABLE IF NOT EXISTS patients (
          id SERIAL PRIMARY KEY NOT NULL,
          name VARCHAR NOT NULL,
          cpf VARCHAR NOT NULL,
          email VARCHAR NOT NULL,
          address VARCHAR NOT NULL,
          city VARCHAR NOT NULL,
          state VARCHAR NOT NULL,
          birthday DATE NOT NULL,
          CONSTRAINT unique_patient_cpf UNIQUE (cpf)
          );')
  db.exec('CREATE TABLE IF NOT EXISTS tests (
          id SERIAL PRIMARY KEY NOT NULL,
          token VARCHAR NOT NULL,
          date DATE NOT NULL,
          patient_id INT NOT NULL REFERENCES patients(id),
          doctor_id INT NOT NULL REFERENCES doctors(id),
          CONSTRAINT unique_test_token UNIQUE (token)
          );')
  db.exec('CREATE TABLE IF NOT EXISTS test_items (
          id SERIAL PRIMARY KEY NOT NULL,
          result INT NOT NULL,
          test_id INT NOT NULL REFERENCES tests(id),
          test_type_id INT NOT NULL REFERENCES test_types(id),
          CONSTRAINT unique_test_item_combination UNIQUE (test_id, test_type_id)
          );')
  db.close
end

task :drop_tables_if_exists do
  db = PG.connect(host: 'postgres-server-test', user: 'postgres')
  db.exec('SET client_min_messages TO WARNING;')
  db.exec('DROP TABLE IF EXISTS doctors CASCADE;')
  db.exec('DROP TABLE IF EXISTS test_types CASCADE;')
  db.exec('DROP TABLE IF EXISTS patients CASCADE;')
  db.exec('DROP TABLE IF EXISTS tests CASCADE;')
  db.exec('DROP TABLE IF EXISTS test_items CASCADE;')
  db.close
end
