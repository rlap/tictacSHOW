class Game < ActiveRecord::Base
  attr_accessible :draw, :losing_user_id, :winning_user_id, :player1_id, :player2_id
  has_and_belongs_to_many :users
  has_many :moves

  BOARD = [:a1, :a2, :a3, :b1, :b2, :b3, :c1, :c2, :c3]
  WINNING_COMBOS = [
    [:a1, :a2, :a3],
    [:b1, :b2, :b3],
    [:c1, :c2, :c3],
    [:a1, :b1, :c1],
    [:a2, :b2, :c2],
    [:a3, :b3, :c3],
    [:a1, :b2, :c3],
    [:a3, :b2, :c1]
  ].to_set

  # Check if game is over
  def game_over
    if winner_present || all_positions_taken
      true
    else
      false
    end
  end

  # Check if winning row or column or diagonal present
  def winner_present
    player1_id = Game.where(:game_id => 2).player1_id
    player1_positions = []
    Move.where(:game_id => 2, :user_id => player1_id).each do |move|
      player1_positions << move.position.to_sym
    end
    player1_positions.to_set

    player2_id = Game.where(:game_id => 2).player2_id
    player2_positions = []
    Move.where(:game_id => 2, :user_id => player2_id).each do |move|
      player2_positions << move.position.to_sym
    end
    player2_positions.to_set
  # NEED TO FIGURE OUT HOW TO DO A DYNAMIC GAME ID && USER ID

    if Game::WINNING_COMBOS.any? { |combo| player1_positions.superset? combo } || Game::WINNING_COMBOS.any? { |combo| player2_positions.superset? combo }
      true
    else
      false
    end
  end

  # Check if all positions have been taken on the board
  def all_positions_taken
    positions_played = []
    Move.where(:game_id => 2).each do |move|
      positions_played << move.position.to_sym
    end
  # NEED TO FIGURE OUT HOW TO DO A DYNAMIC GAME ID
    if (Game::BOARD - positions_played).count == 0
      true
    else 
      false
    end
  end

  # Define current board
  def current_board
    @board = []
    Move.where(:game_id => 2).each do |move|
      @board << move.position.to_sym
    end
  end

end
