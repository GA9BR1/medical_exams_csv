require 'sidekiq'
require_relative 'insertions'

class Worker
  include Sidekiq::Worker
  
  def perform(file)
    Insertions.insert_csv_data(file)
  end
end