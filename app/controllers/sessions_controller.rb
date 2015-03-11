class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # Authenticate method is provided by has_secure_password (ActiveRecord?)
    if user && user.authenticate(params[:session][:password])
      # Log in and render user page
      log_in(user)
      # Start log in session with cookies (see sessions_helper)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # redirect_back_or from sessionhelper so that after creation, the user is
      # redirected back to the page they were trying to access without an account.
      redirect_back_or user
    else
      # flash.now dissapears after next request, unlike flash which dissapears after next redirect.
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new'
    end
  end

  def destroy
    # Make sure that log out only works if the user is logged in (for multiple open windows)
    log_out if logged_in?
    redirect_to root_url
  end
end
