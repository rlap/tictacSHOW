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

  def game_opponent(game)
    if game.player1_id == current_user.id
      game.player2_id
    else
      game.player1_id
    end
  end

  def display_time(game)
    if game.moves.length == 0
      date = game.updated_at.strftime("%d %b %Y")
      time = game.updated_at.strftime("%H:%M")
    else
      date = game.moves.last.updated_at.strftime("%d %b %Y")
      time = game.moves.last.updated_at.strftime("%H:%M")
    end
    date + " " + time
  end

  def game_finish_time(game)
    date = game.updated_at.strftime("%d %b %Y")
    time = game.updated_at.strftime("%H:%M")

    date + " " + time
  end

  def winner(game)
    if game.draw == true
      "Draw"
    else
      User.find(game.winning_user_id).screen_name
    end
  end

  def game_finish_message(game)
    if game.winning_user_id == current_user.id
      "Game over - you won!!!!"
    elsif game.losing_user_id == current_user.id
      "Game over - you got schooled"
    else
      "Game over - draw"
    end
  end

  def points_earned(game)
    if game.winning_user_id == current_user.id
      "+ 100"
    elsif game.losing_user_id == current_user.id
      "-50"
    else
      "+10"
    end
  end
end
