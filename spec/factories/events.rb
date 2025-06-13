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
FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "テストイベント#{n}" }
    place { "東京都新宿区" }
    content { "イベントの詳細説明です。" }
    start_at { 1.week.from_now }
    end_at { 1.week.from_now + 2.hours }
    
    # owner関連の設定
    association :owner, factory: :user
  end
end
