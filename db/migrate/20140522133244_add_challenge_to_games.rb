class AddChallengeToGames < ActiveRecord::Migration
  def change
    add_column :games, :challenge_accepted, :boolean, default: false
  end
end
