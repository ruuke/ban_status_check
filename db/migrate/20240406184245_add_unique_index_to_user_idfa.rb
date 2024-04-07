class AddUniqueIndexToUserIdfa < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :idfa, unique: true
  end
end
