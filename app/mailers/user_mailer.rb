class UserMailer < ApplicationMailer
  def welcome_email
    @url  = 'http://example.com/login'
    mail(to: "axeltaglia@gmail.com", subject: 'Welcome to My Awesome Site')
  end
end
