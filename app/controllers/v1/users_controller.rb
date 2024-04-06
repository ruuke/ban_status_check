# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    def check_status
      result = BanCheck.new.call(params.to_unsafe_hash)

      if result.success?
        render json: { ban_status: result.value! }
      else
        render json: { ban_status: 'error' }
      end
    end
  end
end
