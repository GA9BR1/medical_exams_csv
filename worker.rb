require 'sidekiq'
require_relative 'insertions'

class Worker
  include Sidekiq::Worker

  def perform(file, filename)
    update_status("Working", filename)
    Insertions.insert_csv_data(file)
    update_status("Completed", filename)
  end

  def self.get_job_status(jid)
    redis = Redis.new(host: 'redis', port: '6379')
    redis_key = "job_status:#{jid}"
    redis.get(redis_key)
  end

  def update_status(status, filename)
    redis = Redis.new(host: 'redis', port: '6379')
    redis_key = "job_status:#{jid}"
    redis.set(redis_key, [status, filename, jid].to_json)
  end
end
