class UserMailer < ActionMailer::Base
default :from => "Petsworld"
  def registration_confirmation (user)
@user = user
mail to: user.email,from: "PetsWorld <shazly0120100@gmail.com>" ,subject: "Account activation" 
end
end