module GamesHelper

  def x_or_o(position)
    if @player1_moves.include? position
      image_tag(@game.player1_img_good.player1_board.url)
    elsif @player2_moves.include? position
      if @game.player2_id == 1 #computer
        image_tag("/assets/player2_board_computer_good.png")
      else
        image_tag(@game.player2_img_good.player2_board.url)
      end
    else 
      return link_to("?", new_move_path(@move, position: position, :game_id => @game.id))
    end
  end

  def turn(game)
    if game.moves.length == 0 || game.moves.length.even?
      current_player_id = game.player1_id
      other_player_id = game.player2_id
    else
      current_player_id = game.player2_id
      other_player_id = game.player1_id
    end

    if current_player_id == current_user.id
      "Your turn!"
    else
      "Waiting for #{User.find(other_player_id).screen_name} - hit refresh to peek and see if they've gone"
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
