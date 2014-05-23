class Game < ActiveRecord::Base
  attr_accessible :draw, :losing_user_id, :winning_user_id, :player1_id, :player2_id, :player1_img_good, :player2_img_good, :player1_img_bad, :player2_img_bad
  has_and_belongs_to_many :users
  has_many :moves

  mount_uploader :player1_img_bad, ImageUploader
  mount_uploader :player2_img_bad, ImageUploader
  mount_uploader :player1_img_good, ImageUploader
  mount_uploader :player2_img_good, ImageUploader

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
  CORNERS = [:a1, :a3, :c1, :c3]
  CENTRE = [:b2]

  # Check if game is over
  def game_over
    winner_present || all_positions_taken
  end

  # Check if winning row or column or diagonal present
  def winner_present
    player1_winner || player2_winner
  end

  def player1_winner
    player1_moves = player_moves(1).to_set
    Game::WINNING_COMBOS.any? { |combo| player1_moves.superset?(combo.to_set) }
  end

  def player2_winner
    player2_moves = player_moves(2).to_set
    Game::WINNING_COMBOS.any? { |combo| player2_moves.superset?(combo.to_set) }
  end

  # Check if all positions have been taken on the board
  def all_positions_taken
    (Game::BOARD - current_board).count == 0
  end

  # Randomized computer move
  def computer_move
    (Game::BOARD - current_board).sample
  end


  def player_moves player_number

    user_id = send "player#{player_number}_id"
    moves.where(user_id: user_id).pluck(:position).map(&:to_sym)
  end

  def current_board 
    player_moves(1) + player_moves(2)
  end
end
