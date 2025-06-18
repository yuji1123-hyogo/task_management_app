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
class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  has_many :loans, through: :books
  has_many :current_borrowers, -> { join(:loans).where(loans: { returned_at: nil})},
            through: :books, source: :members
  
  validates :name, presence: true, length: { maximum: 100 }
  validates :bio, length: { maximum: 1000 }

  # スコープ
  scope :with_published_books, -> { joins(:books).distinct }
  scope :popular, -> { joins(:loans).group('authors.id').order('COUNT(loans.id) DESC') }

  # インスタンスメソッド
  def full_name_with_book_count
    "#{name} (#{books.count}冊)"
  end
end
