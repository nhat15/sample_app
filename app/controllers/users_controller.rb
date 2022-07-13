class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def create
    @user = User.new users_params
    if @user.save
      log_in @user
      flash[:success] = t "welcome"
      redirect_to @user
    else 
      flash.now[:danger] = t "user_not_save"
      render :new
    end
  end

  private

  def users_params
    params.require(:user).permit User::USER_ATTR
  end
end
