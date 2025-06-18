# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  isbn         :string           not null
#  published_at :date
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :integer          not null
#
# Indexes
#
#  index_books_on_author_id  (author_id)
#  index_books_on_isbn       (isbn) UNIQUE
#  index_books_on_title      (title)
#
# Foreign Keys
#
#  author_id  (author_id => authors.id)
#
class Book < ApplicationRecord
  belongs_to :author
  has_many :loans, dependent: :destroy
  has_many :members, through: :loans
  has_many :past_borrowers, -> { joins(:loans).where.not(loans: { returned_at: nil }) },
           through: :loans, source: :member

  validates :title, presence: true, length: { maximum: 200 }
  validates :isbn, presence: true, uniqueness: true
  validates :published_at, presence: true 

  scope :available, -> { left_joins(:loans)
                          .where(loans: { returned_at: nil })
                          .where(loans: { id: nil }) }
  scope :borrowed, -> { joins(:loans).where(loans: { returned_at: nil }) }
  scope :published_after, ->(date) { where('published_at > ?', date) }
  scope :by_author_name, ->(name) { joins(:author).where(authors: { name: name }) }
  # インスタンスメソッド
  def available?
    loans.where(returned_at: nil).empty?
  end
  
  def current_loan
    loans.find_by(returned_at: nil)
  end
  
  def borrow_count
    loans.where.not(returned_at: nil).count
  end
end
