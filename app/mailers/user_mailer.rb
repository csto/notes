class UserMailer < ActionMailer::Base
  default from: "noreply@example.com"
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to #{app_name}!")
  end
  
  def share_note_email(user, email, token)
    @user = user
    @email = email
    @token = token
    mail(to: @email, subject: "#{@user.name_or_email} shared a note with you.")
  end
end
