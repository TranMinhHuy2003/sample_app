class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      if user.activated?
        handle_successful_login user
      else
        handle_failed_activated
      end
    else
      handle_failed_login
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  private

  def handle_successful_login user
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    log_in user
    redirect_to forwarding_url || user
  end

  def handle_failed_activated
    flash[:warning] = t("active_mail.not_activated")
    redirect_to root_url, status: :see_other
  end

  def handle_failed_login
    flash.now[:danger] = t("flash.invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
