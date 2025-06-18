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
require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'ファクトリーについて' do
    it '有効なファクトリーを作成できる' do
      valid_member = create(:member)
      expect(valid_member).to be_valid
    end
  end

  describe 'アソシエーションについて' do
    it { should have_many(:books).through(:loans) }
    it { should have_many(:loans).dependent(:destroy) }
  end

  describe 'バリデーションについて' do
    subject { create(:member) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'メソッドについて' do
    let!(:member) { create(:member) }
    context '借用数が3冊未満の場合' do
      it 'trueを返す' do
        create_list(:loan, 2, member: member, returned_at: nil)
        expect(member.can_borrow_more?).to be true
      end
    end
    
    context '借用数が3冊の場合' do
      it 'falseを返す' do
        create_list(:loan, 3, member: member, returned_at: nil)
        expect(member.can_borrow_more?).to be false
      end
    end
  end
end
