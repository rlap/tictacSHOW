class RenameBoard < ActiveRecord::Migration
  def up
    rename_table :boards, :moves
  end

  def down
    rename_table :moves, :boards
  end
end
