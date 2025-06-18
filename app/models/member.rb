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
class Member < ApplicationRecord
    has_many :loans, dependent: :destroy
    has_many :books, through: :loans
    has_many :current_loans, -> { where(returned_at: nil) }, class_name: 'Loan'
    has_many :current_books, through: :current_loans, source: :book

    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, uniqueness: true, format: {  with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, format: { with: /\A\d{10,11}\z/ }, allow_blank: true

    scope :active_borrowers, -> { joins(:cuurrent_loans).distinct }
    scope :with_overdue_books, -> { joins(:current_loans)
                                    .where('loans.borrowed_at < ?', 2.weeks.ago)
                                    .distinct }

    def can_borrow_more?
        current_loans.count < 3
    end

    def overdue_loans
        current_loans.where('borrowed_at < ?', 2.weeks.ago)
    end 
end
