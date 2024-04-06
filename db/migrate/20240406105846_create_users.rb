class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.column :idfa, :string, null: false, unique: true
      t.column :ban_status, :ban_status, default: 'not_banned', null: false

      t.timestamps
    end
  end
end
