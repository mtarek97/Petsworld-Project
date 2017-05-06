class PostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "post created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/welcome'
		end
	end
	def auto_link_usernames(text)
  text.gsub /(?<=\s|^)@[A-Za-z0-9_]+(?=\b)/ do |username|
  link_to(username, user_path(username.gsub('@', '')))
  end.html_safe
end

	def destroy
		@post.destroy
		flash[:success] = "Post deleted"
		redirect_to request.referrer || root_url
	end
def index
  @users = User.search(params[:search])
end
	private
		def post_params
			params.require(:post).permit(:content, :picture,:image)
		end

		def correct_user
			@post = current_user.posts.find_by(id: params[:id])
			redirect_to root_url if @post.nil?
		end
end
