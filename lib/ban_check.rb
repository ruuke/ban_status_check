# frozen_string_literal: true

Dry::Schema.load_extensions(:monads)

class BanCheck
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  RequestSchema = Dry::Schema.JSON do
    required(:idfa).filled(:string)
    required(:rooted_device).filled(:bool)
    required(:cf_ipcountry).filled(:string)
    required(:ip).filled(:string)
  end

  def call(params)
    valid_params = yield validate_params(params)
    user = find_or_create_user(valid_params)
    check_cf_ipcountry(valid_params[:cf_ipcountry], user)
    vpn_check_result = vpn_check(valid_params[:ip])
    save_and_log(user, valid_params, vpn_check_result)
  end

  private

  attr_reader :user

  def validate_params(params)
    RequestSchema.call(params).to_monad
  end

  def find_or_create_user(params)
    @user = User.find_or_initialize_by(idfa: params[:idfa])
    user.ban_status = 'banned' if params[:rooted_device]
    user
  end

  def check_cf_ipcountry(cf_ipcountry, user)
    is_whitelisted = RedisClient.client.sismember('whitelisted_countries', cf_ipcountry)
    user.ban_status = 'banned' unless is_whitelisted
  end

  def vpn_check(ip)
    result = ::VpnCheck.new.call(ip:).value!
    user.ban_status = 'banned' if result[:is_vpn_or_tor]
    result
  end

  def save_and_log(user, params, vpn_check_result)
    if user.new_record? || (user.persisted? && user.ban_status_changed?)
      user.save
      log_integrity_data(user, params, vpn_check_result)
      Success(user.ban_status)
    elsif user.persisted? && !user.ban_status_changed?
      Success(user.ban_status)
    else
      Failure(user: 'could not be saved')
    end
  end

  def log_integrity_data(user, params, vpn_check_result)
    IntegrityLoggerService.new.log(
      user:,
      idfa: user.idfa,
      ban_status: user.ban_status,
      ip: params[:ip],
      rooted_device: params[:rooted_device],
      country: params[:cf_ipcountry],
      proxy: vpn_check_result[:proxy],
      vpn: vpn_check_result[:vpn]
    )
  end
end
