class TagsController < ApplicationController
  def show
    @tag = Tag.find_by!(name: params[:name])
    @posts = @tag.posts.includes(:user).order(created_at: :desc)
  end
end
