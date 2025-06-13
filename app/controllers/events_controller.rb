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
      flash[:danger] = "イベントの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.includes(:participants).find(params[:id])
    @ticket = current_user.tickets.find_by(event: @event)
  end

  def index 
    @q = Event.includes(:owner).ransack(params[:q])
    @events = @q.result(distinct: true)
    @events = apply_custom_filters(@events).page(params[:page]).per(5)
  end

  private

  def event_params
    params.require(:event).permit(:name,:place,:start_at,:end_at,:content)
  end

  def apply_custom_filters(events_scope)
    # 参加状況での絞り込み
    if params[:participation_status].present?
      events_scope = events_scope.by_participation_status(current_user, params[:participation_status])
    end
    events_scope.distinct
  end
end
