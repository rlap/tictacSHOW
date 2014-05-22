class SessionsController < ApplicationController
  def new
    session[:game_id] = params[:game_id] if params[:game_id]
  end

  # Signin
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      #user is authenticated
      session[:user_id] = user.id
      if session[:game_id]
        redirect_to edit_game_path(session[:game_id]) and return
      end
      redirect_to root_path, notice: "you successfully signed in"
    else
      # wrong credentials
      flash.now[:alert] = "Invalid Login Credentials"
      render :new
    end
  end

  # Signout
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
