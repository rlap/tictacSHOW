module GamesHelper

  def x_or_o(position)
    if @player1_moves.include? position
      return 'x'
    elsif @player2_moves.include? position
      return 'o'
    else 
      return "#{position}"
    end
  end

end
