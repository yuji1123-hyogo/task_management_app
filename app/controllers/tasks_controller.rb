class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit]
  def index
    @tasks = Task.all
  end

  def show; end

  def create
    task = Task.new(task_params)
    if task.save
      flash[:success] = "タスクを作成しました"
      redirect_to tasks_path status: :see_other
    else
      @task = task
      flash.now[:danger] = "タスクの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "タスクの更新に成功しました"
      redirect_to tasks_path
    else
      flash.now[:danger] = "タスクの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @task = Task.new
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy!
    flash[:success] = "タスクを削除しました"
    redirect_to tasks_path, status: :see_other
  end

  private

  def task_params
    params.require(:task).permit(:name, :description )
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
