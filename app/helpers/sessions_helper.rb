module SessionsHelper
  def log_in(user)
    session[:id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    current_user ||= User.find_by(id: session[:id])

  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user != nil
  end

end
