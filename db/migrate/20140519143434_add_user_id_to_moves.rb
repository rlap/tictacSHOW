class AddUserIdToMoves < ActiveRecord::Migration
  def up
    add_column :moves, :user_id, :integer
  end

  def down
    remove_column :moves, :user_id
  end
end
