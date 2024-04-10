# frozen_string_literal: true

class IntegrityLoggerService
  def initialize(strategy = DatabaseIntegrityLogger)
    @strategy = strategy
  end

  def log(params)
    @strategy.log(params)
  end
end
