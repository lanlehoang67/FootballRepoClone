# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/send_success_bet
  def send_success_bet
    UserMailer.send_success_bet User.first
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/send_fail_bet
  def send_fail_bet
    UserMailer.send_fail_bet User.first
  end
end
