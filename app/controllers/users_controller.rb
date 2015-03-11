class UsersController < ApplicationController
  # Make sure that only certain users can access edit and update.
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Log user in upon signup
      log_in @user
      # Flash issues message (success, info, warning, danger) that exist only on first reload or redirect.
      flash[:success] = "Welcome to the sample app!"
      # Equivalent to redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private




    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        # Stores location of page that was trying to be access; for friendly forwarding.
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Check to see if the user is the right user to access certain pages
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end
