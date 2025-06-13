require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  before do
    sign_in user
  end

  describe "POST /events/:event_id/tickets" do
    it "イベントに参加できる" do
      expect {
        post event_tickets_path(event), params: { ticket: { comment: "楽しみにしてます" } }
      }.to change(Ticket, :count).by(1)

      expect(response).to redirect_to(event)
      follow_redirect!
      expect(response.body).to include("イベント#{event.name}に参加しました")
    end

    it "すでに参加済みの場合は参加できない" do
      create(:ticket, user: user, event: event)

      expect {
        post event_tickets_path(event), params: { ticket: { comment: "2回目の参加" } }
      }.not_to change(Ticket, :count)

      expect(response).to redirect_to(event)
      follow_redirect!
      expect(response.body).to include("このイベントにはすでに参加済みです")
    end
  end

  describe "DELETE /events/:event_id/tickets" do
    
    it "チケットを削除し、リダイレクトする" do
      ticket = create(:ticket, user: user, event: event)

      expect {
        delete event_ticket_path(event,ticket)
      }.to change(Ticket, :count).by(-1)

      expect(response).to redirect_to(event_path(event))
      follow_redirect!
      expect(response.body).to include("イベントへの参加をキャンセルしました")
    end
  end
end
