class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.user_not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "flash.user_create_success"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params
      .require(:user).permit(User::PERMITTED_ATTRIBUTES)
  end
end