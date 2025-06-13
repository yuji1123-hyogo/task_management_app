# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("member"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ファクトリーの動作確認' do
    it '有効なユーザーデータが作成できること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'データベースに保存できること' do
      user = create(:user)
      expect(user).to be_persisted
      expect(User.count).to eq 1
    end
  end

  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }

    context '全てのフィールドが有効な場合' do
      it '有効であること' do
        expect(user).to be_valid
      end
    end

    context 'nameについて' do
      it '空の場合は無効であること' do
        user.name = ''
        expect(user).to be_invalid

        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'emailについて' do
      it '重複している場合は無効であること' do
        create(:user, email: 'test@email.com')
        dupulicate_user = build(:user, email: 'test@email.com')
        expect(dupulicate_user).to be_invalid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    let(:user){ create(:user) }

    describe 'has_many :posts' do
      it '投稿と関連付けができる' do
        user = create(:user)
        post = create(:post, user: user)
        expect(post.user).to eq user
      end

      it '投稿を作成できる' do
        post = user.posts.create!(title: 'テスト投稿', body: 'test投稿')
        expect(user.posts).to include(post)
        expect(user.posts.count).to eq 1
      end
    end
  end
end
