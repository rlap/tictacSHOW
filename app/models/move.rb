class Move < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  attr_accessible :position, :value, :game_id, :user_id

  validates_presence_of :position, :value, :game_id, :user_id
  
end