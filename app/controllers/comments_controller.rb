class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = "コメントを作成しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントの作成に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    post = comment.post
    
    comment.destroy!
    flash[:success] = "コメントを削除しました"
    redirect_to post
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
