class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      handle_success_micropost
    else
      handle_invalid_micropost
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "flash.micropost_deleted_success"
    else
      flash[:danger] = t "flash.micropost_deleted_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::PERMITTED_ATTRIBUTES
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "flash.micropost_invalid"
    redirect_to request.referer || root_url
  end

  def handle_success_micropost
    flash[:success] = t "flash.micropost_created_success"
    redirect_to root_url
  end

  def handle_invalid_micropost
    @pagy, @feed_items = pagy current_user.feed.newest,
                              items: Settings.items_per_page
    render "static_pages/home", status: :unprocessable_entity
  end
end
