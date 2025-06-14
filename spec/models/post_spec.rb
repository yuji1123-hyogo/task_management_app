# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'ファクトリーの動作確認' do
    it '有効な投稿が作成できる' do
      post = build(:post)
      expect(post).to be_valid
    end
  end

  describe 'バリデーション' do 
    context '全てのフィールドが有効な入力の場合' do
      it '有効であること' do
        post = build(:post)
        expect(post).to be_valid
      end
    end


    context 'titleについて' do 
      it '空の場合無効であること' do
        post = build(:post)
        post.title = ''
        expect(post).to be_invalid
      end
    end

    context 'bodyについて' do
      it '空の場合は無効であること' do
        post = build(:post)
        post.body = ''

        puts post.errors.full_messages
        expect(post).to be_invalid
      end
    end
  end

  describe 'アソシエーションのテスト' do 
    context 'belongs_to :userについて' do 
      it 'userと紐づけられること' do
        user = create(:user)
        post = create(:post,user: user)
        expect(user.posts).to include(post) 
      end

      it 'userがnilであれば無効であること' do
        post = build(:post, user: nil)
        expect(post).to be_invalid
      end
    end

    describe 'has_many :favorites' do
      it '関連が正しく定義されている' do
        association = Post.reflect_on_association(:favorites)
        expect(association.macro).to eq(:has_many)
        expect(association.options[:dependent]).to eq(:destroy)
      end

      it 'ユーザーと紐づけられる' do
        user = create(:user)
        post = create(:post)
        post.favorites.create(user: user)
      end
    end

    describe 'has_many :favorites_user' do
      it '関連が正しく定義されている' do
        association = Post.reflect_on_association(:favorite_users)
        expect(association.macro).to eq(:has_many)
        expect(association.options[:through]).to eq(:favorites)
      end
    end
  end

  describe 'メソッドのテスト' do
    describe '#favorites_count' do
      it 'お気に入り登録しているユーザー数を返す' do
        post = create(:post)
        user = create(:user)
        post.favorites.create(post: post, user:user)
        expect(post.favorites_count).to eq(1)
      end
    end
  end
end
