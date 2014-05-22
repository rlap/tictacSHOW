class AddImagesToGames < ActiveRecord::Migration
  def change
    add_column :games, :player1_img_good, :text
    add_column :games, :player2_img_good, :text
    add_column :games, :player1_img_bad, :text
    add_column :games, :player2_img_bad, :text
  end
end
