class PostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy, :edit , :update]

	def create
		@post = current_user.posts.build(post_params)
		@tags = Tag.all.order('posts_count DESC')
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

	def search
		@post.destroy
		flash[:success] = "Post deleted"
		redirect_to request.referrer || root_url
	end

	def like
		@post=Post.find(params[:id])
		if current_user.likes?(@post)

			current_user.unlike(@post)
		else
			create_notification @post
			current_user.like(@post)
		end	
		redirect_to :back
	end
	
	def show
		@post = Post.find(params[:id])
	end

	def index
		if params[:tag]
			@posts = Post.tagged_with(params[:tag])
			@tag = Tag.where(name: params[:tag]).first
		else
			@posts = Post.all
		end
	end

	def edit
		@post = Post.find(params[:id])  
	end

	def update  
		@post = Post.find(params[:id])
		@post.update(post_params)
		redirect_to(post_path(@post))
	end  

	private
	def post_params
		params.require(:post).permit(:content, :picture,:image , :all_tags)
	end

	def correct_user
		@post = current_user.posts.find_by(id: params[:id])
		redirect_to root_url if @post.nil?
	end

	def create_notification(post)
		return if post.user.id == current_user.id
		Notification.create(user_id: post.user.id,
			notified_by_id: current_user.id,
			post_id: post.id,
			identifier: post.id,
			notice_type: 'like')
	end
end
