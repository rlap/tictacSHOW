class User < ActiveRecord::Base
  attr_accessible :email, :games_drawn, :games_lost, :games_played, :games_won, :password_digest, :score, :password, :password_confirmation, :screen_name

  has_and_belongs_to_many :games
  has_many :moves
  has_secure_password
end
