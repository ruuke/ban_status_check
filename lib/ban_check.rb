# frozen_string_literal: true

Dry::Schema.load_extensions(:monads)

class BanCheck
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  RequestSchema = Dry::Schema.JSON do
    required(:idfa).filled(:string)
    required(:rooted_device).filled(:bool)
    required(:cf_ipcountry).filled(:string)
  end

  def call(params)
    valid_params = yield validate_params(params)
    user = find_or_create_user(valid_params)
    check_cf_ipcountry(valid_params[:cf_ipcountry], user) if user.not_banned?

    if user.save
      Success(user.ban_status)
    else
      Failure(user: 'could not be saved')
    end
  end

  private

  def validate_params(params)
    RequestSchema.call(params).to_monad
  end

  def find_or_create_user(params)
    user = User.find_or_initialize_by(idfa: params[:idfa])
    user.ban_status = 'banned' if params[:rooted_device]
    user
  end

  def check_cf_ipcountry(cf_ipcountry, user)
    is_whitelisted = RedisClient.client.sismember('whitelisted_countries', cf_ipcountry)
    user.ban_status = 'banned' unless is_whitelisted

    user
  end
end
