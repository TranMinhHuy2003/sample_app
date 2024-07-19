class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.order_by_name, items: Settings.items_per_page
  end

  def show
    @pagy, @microposts = pagy @user.microposts, items: Settings.items_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t("active_mail.check_email")
      redirect_to root_url, status: :see_other
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

  def following
    @title = t "follow.following_title"
    @pagy, @users = pagy @user.following, items: Settings.items_per_page
    render :show_follow
  end

  def followers
    @title = t "follow.followers_title"
    @pagy, @users = pagy @user.followers, items: Settings.items_per_page
    render :show_follow
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
