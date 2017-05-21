class UserMailer < ActionMailer::Base
	default :from => "Petsworld"
	def registration_confirmation (user)
		@user = user
		mail to: user.email,from: "PetsWorld <petsworld20csed20@gmail.com>" ,subject: "Account activation" 
	end
end