# frozen_string_literal: true

Dry::Schema.load_extensions(:monads)

class BanCheck
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  RequestSchema = Dry::Schema.JSON do
    required(:idfa).filled(:string)
    required(:rooted_device).filled(:bool)
  end

  def initialize(user_repository: User)
    @user_repository = user_repository
  end

  def call(params)
    valid_params = yield validate_params(params)
    user = yield find_or_create_user(valid_params)
    Success(user.ban_status)
  end

  private

  attr_reader :user_repository

  def validate_params(params)
    RequestSchema.call(params).to_monad
  end

  def find_or_create_user(params)
    user = user_repository.find_or_initialize_by(idfa: params[:idfa])

    return Success(user) if user.persisted? && user.ban_status == 'banned'

    user.save ? Success(user) : Failure(user: 'could not be saved')
  end
end
