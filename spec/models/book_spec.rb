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
require 'rails_helper'
RSpec.describe Book, type: :model do
  let(:book) { create(:book) }
  
  describe 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:loans).dependent(:destroy) }
    it { should have_many(:members).through(:loans) }
  end
  
  describe 'validations' do
    subject { create(:book) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_uniqueness_of(:isbn) }
  end
  
  describe '#available?' do
    context '貸出されていない場合' do
      it 'trueを返す' do
        expect(book.available?).to be true
      end
    end
    
    context '貸出中の場合' do
      it 'falseを返す' do
        create(:loan, book: book, returned_at: nil)
        expect(book.available?).to be false
      end
    end
  end
  
  describe 'scopes' do
    describe '.available' do
      let!(:available_book) { create(:book) }
      let!(:borrowed_book) { create(:book) }
      
      before do
        create(:loan, book: borrowed_book, returned_at: nil)
      end
      
      it '貸出可能な本のみ返す' do
        expect(Book.available).to include(available_book)
        expect(Book.available).not_to include(borrowed_book)
      end
    end
  end
end