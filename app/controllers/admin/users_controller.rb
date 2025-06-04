class Admin::UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー:#{@user.name}を登録しました"
      redirect_to admin_users_path, status: :see_other
    else
      flash[:danger] = "ユーザー作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
