class SessionsController < ApplicationController
  def new
  end

  # Signin
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      #user is authenticated
      session[:user_id] = user.id
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
