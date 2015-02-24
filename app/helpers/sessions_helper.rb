module SessionsHelper
  # Logs in user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Logs users out
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user
  end

  # Returns the current logged in user (if any)
  def current_user
    # Checks first to see if session exists
    if (user_id = session[:user_id])
      # Checks of @current_user is exists (is true), and uses find_by if it doesn't.
      @current_user ||= User.find_by(id: session[:user_id])
    # Checks if cookie exists
    elsif (user_id = cookies.signed[:user_id])
      # raise # way to test whether or not a branch of code is tested. Tests will pass if untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in.
  def logged_in?
    !current_user.nil?
  end

  # Remembers users in a persistent session
  def remember(user)
    user.remember
    # Signed so that the id is not passed openly
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
