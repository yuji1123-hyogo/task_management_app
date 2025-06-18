# == Schema Information
#
# Table name: loans
#
#  id          :integer          not null, primary key
#  borrowed_at :datetime         not null
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :integer          not null
#  member_id   :integer          not null
#
# Indexes
#
#  index_loans_on_book_id               (book_id)
#  index_loans_on_book_member_returned  (book_id,member_id,returned_at)
#  index_loans_on_member_id             (member_id)
#
# Foreign Keys
#
#  book_id    (book_id => books.id)
#  member_id  (member_id => members.id)
#
FactoryBot.define do
  factory :loan do
    association :book
    association :member
    borrowed_at { 1.week.ago }
    returned_at { nil }
    
    trait :returned do
      returned_at { 3.days.ago }
    end
    
    trait :overdue do
      borrowed_at { 3.weeks.ago }
      returned_at { nil }
    end
  end
end
