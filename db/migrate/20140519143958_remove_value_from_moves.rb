class RemoveValueFromMoves < ActiveRecord::Migration
  def up
    remove_column :moves, :value
  end

  def down
    add_column :moves, :value, :integer
  end
end
