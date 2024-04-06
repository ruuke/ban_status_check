class CreateBanStatusEnum < ActiveRecord::Migration[7.0]
  def change
    create_enum :ban_status, ['not_banned', 'banned']
  end
end
