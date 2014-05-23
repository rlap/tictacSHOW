class Move < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  attr_accessible :position, :game_id, :game, :user_id, :user
  
  validate :player_turn

  def player_turn

    if game.moves.length == 0 || game.moves.length.even?
      current_player_id = game.player1_id
    else
      current_player_id = game.player2_id
    end
    unless current_player_id == user.id
      errors[:base] << "NOT YOUR MOVE!!!"
    end
  end

end
