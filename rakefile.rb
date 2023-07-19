require 'pg'

task :create_tables_if_not_exist do
  db = PG.connect(host: 'postgres-server', user: 'postgres')
  result = db.exec("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public'")
  count = result.getvalue(0, 0).to_i
  
  if count == 0
    db.exec('CREATE TABLE doctors (
             id SERIAL PRIMARY KEY NOT NULL,
             name VARCHAR NOT NULL,
             crm VARCHAR NOT NULL,
             crm_state VARCHAR NOT NULL,
             email VARCHAR NOT NULL
            );')
    db.exec('CREATE TABLE test_types (
             id SERIAL PRIMARY KEY NOT NULL,
             name VARCHAR NOT NULL,
             limits VARCHAR NOT NULL
           );')
    db.exec('CREATE TABLE patients (
            id SERIAL PRIMARY KEY NOT NULL,
            name VARCHAR NOT NULL,
            cpf VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            address VARCHAR NOT NULL,
            city VARCHAR NOT NULL,
            state VARCHAR NOT NULL,
            birthday DATE NOT NULL
           );')
    db.exec('CREATE TABLE tests (
            id SERIAL PRIMARY KEY NOT NULL,
            token VARCHAR NOT NULL,
            result INT NOT NULL,
            date DATE NOT NULL,
            patient_id INT NOT NULL REFERENCES patients(id),
            doctor_id INT NOT NULL REFERENCES doctors(id),
            test_type_id INT NOT NULL REFERENCES test_types(id)
           );')
  end
end