# == Schema Information
#
# Table name: tickets
#
#  id         :integer          not null, primary key
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer
#
# Indexes
#
#  index_tickets_on_event_id              (event_id)
#  index_tickets_on_event_id_and_user_id  (event_id,user_id) UNIQUE
#  index_tickets_on_user_id               (user_id)
#
# Foreign Keys
#
#  event_id  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'アソシエーション' do 
    it '有効なファクトリが作成できる' do 
      ticket = build(:ticket)
      expect(ticket).to be_valid
    end
    it 'belons_to:usersが設定されている' do
      association = Ticket.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belons_to:eventsが設定されている' do
      association = Ticket.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
    end


    describe '一意性制約' do 
      let(:user) { create(:user) }
      let(:event) { create(:event) }

      it '同じユーザーが同じイベントに重複してチケットを作成できない' do
        create(:ticket, user: user, event: event)
        
        duplicate_ticket = build(:ticket, user: user, event: event)
        expect(duplicate_ticket).not_to be_valid

        puts duplicate_ticket.errors.full_messages
        expect(duplicate_ticket.errors[:user_id]).to include('このユーザーはすでにこのイベントに登録済みです')
      end
    end
  end
end
