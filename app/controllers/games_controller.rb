class GamesController < ApplicationController

# Show all games 
  def index
    if current_user
      @games = current_user.games
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @boards }
      end
    else
      redirect_to new_session_path
    end
  end

# Show current game
def current_game
  if !current_user.nil? && current_user.moves.length != 0
    @game = Game.find(current_user.moves.last.game_id)
    redirect_to game_path(@game)
  else
    redirect_to new_session_path
  end
end

# Show active games
def active_games
  if !current_user.nil? && current_user.moves.length != 0
    @games = current_user.games.where(:finished => false).order("updated_at DESC")
    render "active_games"
  else
    redirect_to new_session_path
  end
end

# Show games history
def games_history
  if !current_user.nil? && current_user.moves.length != 0
    @games = current_user.games.where(:finished => true).order("updated_at DESC")
    render "games_history"
  else
    redirect_to new_session_path
  end
end

# Show game board
  def show
    @game = Game.find(params[:id])

    if @game.game_over
      render :game_finished
    else
      render :show
    end
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
    @game = Game.create(params[:game])

    if params[:new_player_email].present?
      if User.find_by_email(params[:new_player_email])
        @user = User.find_by_email(params[:new_player_email])
        @game.player2_id = @user.id
        UserMailer.challenge_invitation_already_user(current_user, @user, @game).deliver
      else
        @new_user = User.create({
          email: params[:new_player_email],
          password: "tictacshow",
          password_confirmation: "tictacshow",
        })
        @game.player2_id = @new_user.id
        UserMailer.challenge_invitation(current_user, @new_user, @game).deliver
      end
    end

    @game.player1_id = current_user.id

    if @game.player2_id == 1
      @game.challenge_accepted = true
    end

    @game.users << current_user
    @game.users << User.find(@game.player2_id)

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

  def edit
    @game = Game.find(session[:game_id])
  end

  def update
    @game = Game.find(session[:game_id])
    @game.challenge_accepted = true

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
