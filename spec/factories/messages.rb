# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  context     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  reciever_id :integer          not null
#  sender_id   :integer          not null
#
# Indexes
#
#  index_messages_on_reciever_id  (reciever_id)
#  index_messages_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  reciever_id  (reciever_id => users.id)
#  sender_id    (sender_id => users.id)
#
FactoryBot.define do
  factory :message do
    sender { nil }
    reciever { nil }
    context { "MyText" }
  end
end
