class UserMailer < ActionMailer::Base
default :from => "Petsworld"
  def registration_confirmation (user)
@user = user
mail to: user.email, subject: "Account activation"
end
end