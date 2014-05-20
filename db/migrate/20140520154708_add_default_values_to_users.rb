class AddDefaultValuesToUsers < ActiveRecord::Migration
  def change
    change_column :users, :score, :integer, default: 0
    change_column :users, :games_played, :integer, default: 0
    change_column :users, :games_won, :integer, default: 0
    change_column :users, :games_lost, :integer, default: 0
    change_column :users, :games_drawn, :integer, default: 0
  end
end
