class Admin::UsersController < ApplicationController
  # before_action :ensure_admin!, except: [:new, :create, :index]
  before_action :authenticate_user!
  
  def index
    @users = User.all
  end
  
  def destroy
    user = User.find(params[:id])
    user.destroy!
    flash[:success] = "ユーザーを削除しました"
    redirect_to admin_users_path, status: :see_other
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー #{@user.name} を作成しました"
      redirect_to admin_users_path, status: :see_other
    else
      flash[:alert] = "ユーザーの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "ユーザー #{@user.name} を更新しました"
      redirect_to admin_users_path, status: :see_other
    else
      flash[:alert] = "ユーザーの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation ,:role)
  end

  def set_member
    @user = User.member.find(params[:id])
  end

  #管理者以外のユーザーをはじく
  def ensure_admin!
    redirect_to root_path, alert: "アクセス権限がありません" unless current_user.admin?
  end
end
