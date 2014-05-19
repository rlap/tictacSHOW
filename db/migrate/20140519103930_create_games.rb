class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :winning_user_id
      t.integer :losing_user_id
      t.boolean :draw

      t.timestamps
    end
  end
end
