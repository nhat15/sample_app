class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show
    @pagy, @microposts = pagy @user.microposts
  end

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

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email_message"
      redirect_to root_path
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

  def following
    @title = t "following"
    @pagy, @users = pagy @user.following
    render :show_follow
  end

  def followers
    @title = t "followers"
    @pagy, @users = pagy @user.followers
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit User::USER_ATTR
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

    flash[:danger] = t "not_found"
    redirect_to root_path
  end
end
