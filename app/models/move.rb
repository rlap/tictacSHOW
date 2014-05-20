class Move < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  attr_accessible :position, :game_id, :user_id
  
end
