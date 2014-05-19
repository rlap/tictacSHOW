class CreateGamesUsersTable < ActiveRecord::Migration
  def change
    create_table :games_users, id: false do |t|
      t.belongs_to :game
      t.belongs_to :user
    end
  end
end
