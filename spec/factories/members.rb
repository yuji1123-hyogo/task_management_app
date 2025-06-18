# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_members_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :member do
    name { "alice" }
    email { "example@email.com" }
    phone { "00000000000" }
  end
end
