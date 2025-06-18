# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  bio        :text
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authors_on_name  (name)
#
FactoryBot.define do
  factory :author do
    name { "alice" }
    bio { "my name is alice!" }
  end
end
