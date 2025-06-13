class TicketsController < ApplicationController
  def create 
    event = Event.find(params[:event_id])
    @ticket = current_user.tickets.build do |t|
      t.event = event
      t.comment = params[:ticket][:comment]
    end

    

    if event.participants.include?(current_user)
      flash[:alert] = "このイベントにはすでに参加済みです"
      redirect_to event
    end

    if @ticket.save
      flash[:notice] = "イベント#{event.name}に参加しました"
      redirect_to event
    end
  end


  def destroy
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    ticket.destroy!
    flash[:danger] = "イベントへの参加をキャンセルしました"
    redirect_to event_path(params[:event_id])
  end
end
