class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("active_mail.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("password_reset.subject")
  end
end
