require 'pg'
require 'json'
require 'debug'
class Insertions
  def self.insert_csv_data(file)
    db = PG.connect(host: 'postgres-server', user: 'postgres')
    data = self.read_and_parse_csv_to_json(file)

    data.each do |object|
      self.insert_patient_if_not_exists(object, db)
      self.insert_doctor_if_not_exists(object, db)
      self.insert_test_type_if_not_exists(object, db)
      self.insert_test_and_test_items_if_not_exist(object, db)
    end

    puts 'AAAAAAAAAAAAAAAAA'
  end

  private
  
    def self.read_and_parse_csv_to_json(file)
      rows = CSV.read(file, col_sep: ';')
      columns = rows.shift
      json = rows.map do |row|
                row.each_with_object({}).with_index do |(cell, acc), idx|
                  column = columns[idx]
                  acc[column] = cell
                end
              end.to_json
      data = JSON.parse(json)
    end

    def self.insert_patient_if_not_exists(object, db)
      patient_not_exists = db.exec_params('SELECT * FROM patients WHERE cpf = $1', [object['cpf']]).num_tuples.zero?
      if patient_not_exists
        patient_id = db.exec_params('INSERT INTO patients (name, cpf, email, birthday, address, city, state) VALUES ($1, $2, $3, $4, $5, $6, $7)',
                    [object['nome paciente'], object['cpf'], object['email paciente'], 
                    object['data nascimento paciente'], object['endereço/rua paciente'],
                    object['cidade paciente'], object['estado patiente']])
      end
    end

    def self.insert_doctor_if_not_exists(object, db)
      doctor_not_exists = db.exec_params('SELECT * FROM doctors WHERE crm = $1', [object['crm médico']]).num_tuples.zero?
      if doctor_not_exists
        db.exec_params('INSERT INTO doctors (name, crm, crm_state, email) VALUES ($1, $2, $3, $4)',
                [object['nome médico'], object['crm médico'], object['crm médico estado'], 
                object['email médico']])
      end
    end

    def self.insert_test_type_if_not_exists(object, db)
      test_type_not_exists = db.exec_params('SELECT * FROM test_types WHERE name = $1', [object['tipo exame']]).num_tuples.zero?
      if test_type_not_exists
        db.exec_params('INSERT INTO test_types (name, limits) VALUES ($1, $2) RETURNING id',
        [object['tipo exame'], object['limites tipo exame']])
      end
    end

    def self.insert_test_and_test_items_if_not_exist(object, db)
      test_not_exists = db.exec_params('SELECT * FROM tests WHERE token = $1', [object['token resultado exame']]).num_tuples.zero?
      test_type_id = db.exec_params('SELECT id FROM test_types WHERE name = $1', [object['tipo exame']])[0]['id'].to_i
        if test_not_exists
          patient_id = db.exec_params('SELECT id FROM patients WHERE cpf = $1', [object['cpf']])[0]['id'].to_i
          doctor_id = db.exec_params('SELECT id FROM doctors WHERE crm = $1', [object['crm médico']])[0]['id'].to_i
          db.exec_params('INSERT INTO tests (token, patient_id, doctor_id, date) VALUES ($1, $2, $3, $4)',
                  [object['token resultado exame'], patient_id, doctor_id, object['data exame']])
          test_id = db.exec_params('SELECT * FROM tests WHERE token = $1', [object['token resultado exame']])[0]['id'].to_i

          db.exec_params('INSERT INTO test_items (result, test_type_id, test_id) VALUES ($1, $2, $3)',
                  [object['resultado tipo exame'], test_type_id, test_id])
        else
          test_id = db.exec_params('SELECT * FROM tests WHERE token = $1', [object['token resultado exame']])[0]['id'].to_i
          test_item_not_exists = db.exec_params('SELECT * FROM test_items ti
                                                 JOIN test_types tt ON ti.test_type_id = tt.id
                                                 WHERE ti.test_id = $1 AND tt.name = $2', [test_id, object['tipo exame']]).num_tuples.zero?
          if test_item_not_exists
            db.exec_params('INSERT INTO test_items (result, test_type_id, test_id) VALUES ($1, $2, $3)',
                  [object['resultado tipo exame'], test_type_id, test_id])
          end
        end
    end
end