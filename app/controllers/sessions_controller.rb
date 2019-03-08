class SessionsController < ApplicationController
  def new
    #just renders the form
  end

  def create
    user = User.find_by(username: params[:session][:username])

    if user && user.authenticate(params[:session][:password])
      session[:id] = user.id
      redirect_to play_path(session[:id])
    else
      flash[:notice] = "That didn't work"
      render :new
    end

  end

  def destroy
    session.clear
  end

end
