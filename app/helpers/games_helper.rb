module GamesHelper

  def x_or_o(position)
    if @player1_moves.include? position
      return 'x'
    elsif @player2_moves.include? position
      return 'o'
    else 
      return link_to(position, new_move_path(@move, position: position, :game_id => @game.id))
    end
  end

end
