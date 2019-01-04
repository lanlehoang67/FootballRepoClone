class UserMailer < ApplicationMailer
  def send_success_bet user
    @user = user
    mail to: user.email, subject: t("user_mailer.won")
  end

  def send_fail_bet user
    @user = user
    mail to: user.email, subject: t("user_mailer.lost")
  end
end
