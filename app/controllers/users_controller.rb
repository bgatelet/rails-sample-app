class UsersController < ApplicationController

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

  private


    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
