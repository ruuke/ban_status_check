class CreateIntegrityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :integrity_logs do |t|
      t.references :user
      t.string :idfa
      t.string :ban_status
      t.string :ip
      t.boolean :rooted_device
      t.string :country
      t.boolean :proxy
      t.boolean :vpn

      t.timestamps
    end
  end
end
