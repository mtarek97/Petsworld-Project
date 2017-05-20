class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
		:following, :followers]
		before_action :correct_user, only: [:edit, :update]
		before_action :admin_user, only: :destroy

		def following
			@title = "Following"
			@user = User.find(params[:id])
			@users = @user.following.paginate(page: params[:page])
			render 'show_follow'
		end

		def followers
			@title = "Followers"
			@user = User.find(params[:id])
			@users = @user.followers.paginate(page: params[:page])
			render 'show_follow'
		end

		def username_show
			@user = User.where(username: params[:username]).first
			render 'show'
		end

		def index
			if params[:search]
				@users = User.search(params[:search]).order("created_at DESC")

			else
				@users = User.all.order('created_at DESC')

			end
		end
		def confirm_email
			@user= User.find_by_confirm_token(params[:id])
			if @user
				@user.email_activate
				flash[:success]='welcome'
				redirect_to root_url
			else
				flash[:error]='Error accured'
				redirect_to root_url
			end

		end

		def show
			@user = User.find(params[:id])
			@posts = @user.posts.paginate(page: params[:page])
		end

		def new
			@user = User.new
		end
		def create
			@user = User.new(user_params)
			if @user.save
				UserMailer.registration_confirmation(@user).deliver
				flash[:success] = "confirmation email has been sent"
				render 'sessions/new'
			else
				render 'new'
			end
		end

		def edit
			@user = User.find(params[:id])
		end

		def update
			@user = User.find(params[:id])
			@user.update(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
			
			
		end

		def destroy
			User.find(params[:id]).destroy
			flash[:success] = "User deleted"
			redirect_to users_url
		end

		private
		def user_params
			params.require(:user).permit( :first_name,:last_name,:user_name, :email, :password, :animaltype, :animalgender,:animalname,:password_confirmation,:picture)
		end

	# Before filters

	# Confirms the correct user.
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	# Confirms an admin user.
	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end
end
