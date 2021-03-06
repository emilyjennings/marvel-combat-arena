class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])

    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to parent_path(session[:id])
    else
      flash[:notice] = "That didn't work"
      render :new
    end

  end

  def destroy
    session.clear
  end

end
