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
class Loan < ApplicationRecord
  # アソシエーション
  belongs_to :book
  belongs_to :member
  
  # バリデーション
  validates :borrowed_at, presence: true
  validates :book_id, uniqueness: { scope: [:member_id, :returned_at], 
                                   conditions: -> { where(returned_at: nil) },
                                   message: "は既に借りています" }
  validate :book_must_be_available
  validate :member_can_borrow_more
  
  # スコープ
  scope :current, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
  scope :overdue, -> { current.where('borrowed_at < ?', 2.weeks.ago) }
  
  # インスタンスメソッド
  def return_book!
    update!(returned_at: Time.current)
  end
  
  def overdue?
    returned_at.nil? && borrowed_at < 2.weeks.ago
  end
  
  def loan_period
    end_time = returned_at || Time.current
    ((end_time - borrowed_at) / 1.day).to_i
  end
  
  private
  
  def book_must_be_available
    return unless book && borrowed_at && returned_at.nil?
    
    if book.loans.where(returned_at: nil).where.not(id: id).exists?
      errors.add(:book, "は既に貸出中です")
    end
  end
  
  def member_can_borrow_more
    return unless member && returned_at.nil?
    
    current_loans_count = member.loans.where(returned_at: nil).where.not(id: id).count
    if current_loans_count >= 3
      errors.add(:member, "は借用上限に達しています")
    end
  end
end
