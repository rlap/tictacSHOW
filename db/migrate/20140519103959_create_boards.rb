class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :position
      t.integer :value
      t.references :game

      t.timestamps
    end
    add_index :boards, :game_id
  end
end
