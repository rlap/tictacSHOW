class AddPlayer1Player2ToGames < ActiveRecord::Migration
  def up
    add_column :games, :player1_id, :integer
    add_column :games, :player2_id, :integer
  end

  def down
    remove_column :games, :player1_id
    remove_column :games, :player2_id
  end
end
