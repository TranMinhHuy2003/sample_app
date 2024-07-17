class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.order_by_name, items: Settings.items_per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      reset_session
      log_in @user
      flash[:success] = t "flash.user_create_success"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "flash.profile_update_success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "activerecord.user_deleted"
    else
      flash[:danger] = t "activerecord.delete_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params
      .require(:user).permit(User::PERMITTED_ATTRIBUTES)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.user_not_found"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "activerecord.please_log_in"
    redirect_to login_url
  end

  def correct_user
    return if current_user? @user

    flash[:error] = t "activerecord.can_not_edit_account"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:error] = t "activerecord.not_admin"
    redirect_to root_path
  end
end
