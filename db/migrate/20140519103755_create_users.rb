class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :score
      t.integer :games_played
      t.integer :games_won
      t.integer :games_lost
      t.integer :games_drawn

      t.timestamps
    end
  end
end
