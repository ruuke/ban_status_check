# frozen_string_literal: true

class DatabaseIntegrityLogger
  extend IntegrityLoggerStrategy

  def self.log(params)
    IntegrityLog.create(params)
  rescue StandardError => e
    Rails.logger.error("Database logging failed: #{e.message}")
  end
end
