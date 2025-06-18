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
FactoryBot.define do
  factory :book do
    title { "スラムダンク" }
    sequence(:isbn ){ |n| "A#{n}" }
    published_at { "2025-06-18" }
    author 
  end
end
