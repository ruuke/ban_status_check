# frozen_string_literal: true

module IntegrityLoggerStrategy
  def self.log(params)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
