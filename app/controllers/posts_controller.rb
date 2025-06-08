class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿[#{@post.title}]を作成しました"
      redirect_to posts_path, status: :see_other
    else
      flash[:alert] = "投稿の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    flash[:success] = "投稿を削除しました"
    redirect_to posts_path
  end

  def show
    @post = Post.includes(:user, comments: :user).find(params[:id])
    @comments = @post.comments.order(created_at: :asc)
    @comment = Comment.new
  end

  private

  def post_params
    params.require(:post).permit( :title, :body)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
