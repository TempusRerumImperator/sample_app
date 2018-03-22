module SessionsHelper

  # Log in the user supplied
  def log_in(user)
    session[:user_id] = user.id
  end

  # Return currently logged in user, else nil
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Check if user logged in, false if nil
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
