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
require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'ファクトリーについて' do
    it '有効なファクトリーが作成できる' do
      valid_author = create(:author)
      expect(valid_author).to be_valid
    end
  end

  describe 'アソシエーションについて' do
    it { should have_many(:books).dependent(:destroy) }
    it { should have_many(:loans).through(:books) }
  end

  describe 'バリデーションについて' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_length_of(:bio).is_at_most(1000) }
  end

  describe 'メソッドについて' do
    describe '#full_name_with_book_count' do
      it '著者名と本の冊数を返す' do
      end
    end
  end
end
