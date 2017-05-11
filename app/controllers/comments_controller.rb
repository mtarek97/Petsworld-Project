class CommentsController < ApplicationController
	before_action :find_commentable

	def new
		@comment = Comment.new
	end

	def create
		@comment = @commentable.comments.new comment_params
		@comment.user_id = current_user.id

		if @comment.save
			if (@comment.commentable_type == "Post")
				flash[:success] = "Your comment was successfully added!"
				redirect_to :back
			elsif (@comment.commentable_type == "Comment")
				flash[:success] = "Your Reply was successfully added!"
				redirect_to :back
			end
		else
			if (@comment.commentable_type == "Post")
				flash[:danger] = "Your comment wasn't added!"
			elsif (@comment.commentable_type == "Comment")
				flash[:danger] = "Your reply wasn't added!"
			end
			redirect_to :back
		end
	end

	def destroy
		@comment = @commentable.comments.find(params[:id])
		if (@comment.commentable_type == "Post")
			@comment.destroy
			flash[:success] = "Comment deleted :("
		elsif (@comment.commentable_type == "Comment")
			@comment.destroy
			flash[:success] = "Reply deleted :("
		end
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

