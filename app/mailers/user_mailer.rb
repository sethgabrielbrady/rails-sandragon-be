class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: 'Reset your password')
  end

  def signup_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm your Sandragon account')
  end
end