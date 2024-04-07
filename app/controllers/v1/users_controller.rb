# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    def check_status
      result = BanCheck.new.call(
        params.to_unsafe_hash
        .merge(cf_ipcountry: request.headers['CF-IPCountry'], ip: request.remote_ip)
      )

      if result.success?
        render json: { ban_status: result.value! }
      else
        render json: { errors: result.failure.errors.to_h }, status: :bad_request
      end
    end
  end
end
