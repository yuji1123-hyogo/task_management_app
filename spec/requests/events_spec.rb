require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user){ create(:user) }



  describe "GET /events" do
    before do
      sign_in user 
      create_list(:event, 3, owner: user)
    end

    it "イベント一覧が表示される" do
      get events_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("イベント一覧")
    end

    it "イベントの基本情報が表示される" do
      event = create(:event)
      get events_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(event.name) 
    end

    context "検索・フィルタリング機能について" do
      it "イベント名で検索できる" do
        target_event = create(:event, name: "検索対象")
        other_event = create(:event, name: "検索結果に表示されないもの")
        get events_path, params: { 
          q: {
          name_or_owner_name_cont: target_event.name
          }
        }
        expect(response.body).to include(target_event.name)
        expect(response.body).not_to include(other_event.name)
      end
    end
  end

  # describe "GET /events/:id" do
  #   it "works! (now write some real specs)" do
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe "POST /events" do
    before { sign_in user }

    context '有効なパラメータの場合' do
      let(:valid_params){ attributes_for(:event, name: '有効なイベント')}
      it 'イベントを作成できる' do
        expect {
          post events_path, params: { event: valid_params }
        }.to change(Event,:count).by(1)

        expect(Event.last.owner).to eq(user)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params){ attributes_for(:event, name: '' ) }
      it 'イベントを作成できない' do
        expect {
          post events_path, params: { event: invalid_params }
        }.not_to change(Event, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
    end
  end
end
