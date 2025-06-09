class EventsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      flash[:success] = "イベントを作成しました"
      redirect_to event_path(@event)
    else
      binding.pry
      flash[:danger] = "イベントの作成に失敗しました"
      render :new
    end
  end

  def show
    @event = Event.includes(:participants).find(params[:id])
    @ticket = current_user.tickets.find_by(event: @event)
  end

  def index 
    @events = Event.all
  end

  def destroy
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    ticket.destroy!
    flash[:danger] = "イベントへの参加をキャンセルしました"
    redirect_to event_path(params[:event_id])
  end

  private

  def event_params
    params.require(:event).permit(:name,:place,:start_at,:end_at,:content)
  end
end
