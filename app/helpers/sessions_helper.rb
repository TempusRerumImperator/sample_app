module SessionsHelper

  # Log in the user supplied
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Return currently logged in user, else nil (checking the remember cookie)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Check if user logged in, false if nil
  def logged_in?
    !current_user.nil?
  end

  # Log out current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Remember user with a persistent session cookie
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forget persistent sessions
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Redirect to stored location (or default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Store the forwarding url for friendly forwarding
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
