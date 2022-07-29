class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_delete"
    else
      flash[:danger] = t "delete_failed"
    end
    redirect_to users_url
  end

  def index
    @pagy, @users = pagy User.incre_order,
                         items: Settings.admin.user_per_page
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "welcome"
      redirect_to @user
    else
      flash.now[:danger] = t "user_not_save"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t "update_fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_ATTR
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in."
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "not_correct"
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "not_admin"
    redirect_to root_path
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end
end
