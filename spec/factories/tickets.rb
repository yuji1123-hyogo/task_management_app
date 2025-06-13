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
FactoryBot.define do
  factory :ticket do
    user
    event
  end
end
