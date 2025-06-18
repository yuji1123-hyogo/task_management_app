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
# spec/models/loan_spec.rb
require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:loan) { create(:loan) }
  
  describe 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:member) }
  end
  
  describe 'validations' do
    subject { build(:loan, book: build(:book), member: build(:member)) }
    it { should validate_presence_of(:borrowed_at) }
    
    context '同じ本を複数回借りようとした場合' do
      let(:member) { create(:member) }
      let(:book) { create(:book) }
      
      it 'エラーになる' do
        create(:loan, book: book, member: member, returned_at: nil)
        duplicate_loan = build(:loan, book: book, member: member, returned_at: nil)
        expect(duplicate_loan).not_to be_valid
        expect(duplicate_loan.errors[:book_id]).to include('は既に借りています')
      end
    end
  end
  
  describe '#return_book!' do
    it '返却日時を設定する' do
      loan = create(:loan, returned_at: nil)
      expect { loan.return_book! }.to change { loan.returned_at }.from(nil)
    end
  end
  
  describe '#overdue?' do
    it '2週間以上経過していて未返却の場合trueを返す' do
      loan = create(:loan, borrowed_at: 3.weeks.ago, returned_at: nil)
      expect(loan.overdue?).to be true
    end
  end
end
