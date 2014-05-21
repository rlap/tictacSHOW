class GamesController < ApplicationController

# Show all games 
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boards }
    end
  end

# Show game board
  def show
    @game = Game.find(params[:id])

    if @game.moves.where(:user_id => @game.player1_id)
      @player1_moves = @game.moves.where(:user_id => @game.player1_id).map do |move|
        move.position.to_sym
      end
    else
      @player1_moves = []
    end

    if @game.moves.where(:user_id => @game.player2_id)
      @player2_moves = @game.moves.where(:user_id => @game.player2_id).map do |move|
        move.position.to_sym
      end
    else
      @player2_moves = []
    end

    @current_board = @player1_moves + @player2_moves

    if @game.game_over
      game_finished
    else

      if @game.moves.length != 0 && @game.moves.first.user_id == current_user.id
        position = (Game::BOARD - @current_board).sample
        @game.moves.create(
          :position => position,
          :user_id => 1, # Computer assumed to be user '1'
          :game_id => @game.id
          )
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @game }
      end
    end
  end

  # Game over 
  def game_finished
    @game = Game.find(params[:id])
    @player1 = User.find(@game.player1_id)
    @player2 = User.find(@game.player2_id)

    @player1.games_played += 1
    @player2.games_played += 1

    if @game.player1_winner
      @game.winning_user_id = @game.player1_id
      @game.losing_user_id = @game.player2_id

      @player1.games_won += 1
      @player2.games_lost += 1

      @player1.score += 100
      @player2.score -= 50

    elsif @game.player2_winner
      @game.winning_user_id = @game.player2_id
      @game.losing_user_id = @game.player1_id

      @player2.games_won += 1
      @player1.games_lost += 1

      @player2.score += 100
      @player1.score -= 50

    else
      @game.draw = true

      @player1.games_drawn += 1
      @player2.games_drawn += 1

      @player1.score += 10
      @player2.score += 10

    end

    @player1.save
    @player2.save

    render "game_finished"
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])
    @game.player1_id = current_user.id
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
