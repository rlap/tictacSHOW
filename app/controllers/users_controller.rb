class UsersController < ApplicationController
  # Welcome page
  def welcome
    if !current_user 
      render "welcome"
    elsif current_user.games.length > 0 
      redirect_to game_path(current_user.games.last)
    else
      render "starting_menu"
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

# Show leaderboard
def leaderboard
  @users = User.all
  render "leaderboard"
end

# Sign up page
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

# Sign up
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to new_session_path, notice: 'User was successfully created and logged in' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end
