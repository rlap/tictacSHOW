class Game < ActiveRecord::Base
  attr_accessible :draw, :losing_user, :losing_user_id, :winning_user, :winning_user_id, :player1, :player1_id, :player2, :player2_id, :player1_img_good, :player2_img_good, :player1_img_bad, :player2_img_bad
  has_and_belongs_to_many :users
  has_many :moves

  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User"
  belongs_to :winning_user, class_name: "User"
  belongs_to :losing_user, class_name: "User"

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

  def player1_moves
    player_moves(1).to_set
  end

  def player2_moves
    player_moves(2).to_set
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


  def player_moves(player_number)
    user_id = send "player#{player_number}_id"
    moves.where(user_id: user_id).pluck(:position).map(&:to_sym)
  end

  def current_board 
    player_moves(1) + player_moves(2)
  end

  def conclude!

    player1.games_played += 1
    player2.games_played += 1
    self.finished = true

    if player1_winner
      self.winning_user = player1
      self.losing_user = player2

      player1.games_won += 1
      player2.games_lost += 1

      player1.score += 100
      player2.score -= 50

    elsif player2_winner
      winning_user = player2
      losing_user = player1

      player2.games_won += 1
      player1.games_lost += 1

      player2.score += 100
      player1.score -= 50

    else
      self.draw = true

      player1.games_drawn += 1
      player2.games_drawn += 1

      player1.score += 10
      player2.score += 10

    end

    player1.save
    player2.save
    save
  end

  def ai_opponent?
    player1_id == 1 || player2_id == 1
  end

  def empty_positions
    Game::BOARD - current_board
  end

  def ai_move
    position = empty_positions.sample
    moves.create(
      :position => position,
      :user_id  => 1, # Computer assumed to be user '1'
      :game     => self
    )
  end

end

