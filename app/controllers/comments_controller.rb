class CommentsController < ApplicationController
	before_action :find_commentable

	def new
		@comment = Comment.new
	end

	def create
		@comment = @commentable.comments.new comment_params
		@comment.user_id = current_user.id

		if @comment.save
			flash[:success] = "Your comment was successfully posted!"
			redirect_to :back
		else
			flash[:danger] = "Your comment wasn't posted!"
			redirect_to :back
		end
	end

	def destroy  
		@comment = @post.comments.find(params[:id])

		@comment.destroy
		flash[:success] = "Comment deleted :("
		redirect_to :back
	end  

	private

	def comment_params
		params.require(:comment).permit(:body)
	end

	def find_commentable
		@commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
		@commentable = Post.find_by_id(params[:post_id]) if params[:post_id]
	end
end

