# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  content    :text
#  end_at     :datetime
#  name       :string
#  place      :string
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#
# Indexes
#
#  index_events_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  owner_id  (owner_id => users.id)
#
require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'ファクトリーボットの動作確認' do
    it '有効なイベントが作成できる' do 
      event = build(:event)
      expect(event).to be_valid
    end
  end

  describe 'バリデーション' do 
    let (:event) { build(:event) }

    describe 'nameについて' do
      it '51文字以上の時無効である' do 
        event.name = 'a' * 51
        expect(event).to be_invalid
      end
    end

    describe 'カスタムバリデーション start_at_should_before_end_at' do 
      context '正常な場合' do
        it '開始時間が終了時間より前の場合は有効' do
          event = build(:event,
                        start_at: Time.current,
                        end_at: Time.current + 2.hours)
          expect(event).to be_valid
        end
      end
      context '異常な場合' do
        it '開始時間が終了時間より前の場合は無効' do
           event = build(:event,
                        start_at: Time.current,
                        end_at: Time.current - 1.hours)
          expect(event).to be_invalid 
          expect(event.errors[:start_at]).to include('は終了時間よりも前に設定してください')
        end
      end
    end
  end

  describe 'スコープ' do
    describe '.participated_by_user' do 
      it 'ユーザーが参加しているイベントを返す' do 
        user = build(:user)
        event = build(:event)
        create(:ticket, user:user, event:event)
        result = Event.participated_by_user(user)
        expect(result).to include(event)
      end
    end
  end

  describe 'アソシエーション' do
    describe 'has_many :tickets について' do
      it '関連が正しく設定されている' do
        association = Event.reflect_on_association(:tickets)
        expect(association.macro).to eq :has_many
        expect(association.options[:dependent]).to eq :destroy
      end

      it 'ユーザーがイベントに参加できる' do

      end
    end

    describe 'has_many :participants, through: :tickets, source: :userについて' do
      it '関連が正しく設定されている' do

      end


      it 'ユーザーがイベントに参加できる' do 

      end

    end

  end
end
