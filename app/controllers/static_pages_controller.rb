class StaticPagesController < ApplicationController
	

	def welcome
		if logged_in?
			@post = current_user.posts.build
			@feed_items = current_user.feed.paginate(page: params[:page])
			@tags = Tag.all
		end
	end

	def help
	end

	def about
	end

	def contact
	end
end
