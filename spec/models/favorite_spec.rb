# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_favorites_on_post_id              (post_id)
#  index_favorites_on_user_id              (user_id)
#  index_favorites_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#  user_id  (user_id => users.id)
#
RSpec.describe Favorite, type: :model do
  it '有効なファクトリを生成できる' do
    favorite = build(:favorite)
    expect(favorite).to be_valid
  end

  describe 'バリデーションのテスト' do
    let(:user){ create(:user) }
    let(:post){ create(:post) }

    context '全ての属性が有効である場合' do
      it '有効であること' do
        favorite = Favorite.new(user: user, post: post)
        expect(favorite).to be_valid
      end
    end

    describe 'userについて' do
      it 'nilの時無効であること' do
        favorite = Favorite.new(user: nil, post: post)
        expect(favorite).to be_invalid      
      end
    end

    describe 'postについて' do
      it 'nilの時無効であること' do
        favorite = Favorite.new(user: user, post: nil)
        expect(favorite).to be_invalid 
      end
    end

    describe 'userとpostの組み合わせについて' do
      it '重複した登録は無効であること' do
        create(:favorite, user: user, post: post)
        duplicate_favorite = build(:favorite, user: user, post: post)
        expect(duplicate_favorite).to be_invalid
        expect(duplicate_favorite.errors[:user_id]).to include('はすでに存在します')
      end

      it '同じユーザーに対して異なるポストとの組み合わせは許可すること' do
        post1 = create(:post)
        post2 = create(:post)
        create(:favorite, user: user , post: post1 )
        duplicate_favorite = create(:favorite, user: user, post: post2 )
        expect(duplicate_favorite).to be_valid       
      end
    end
  end

  describe 'アソシエーションのテスト' do
    describe 'belongs_to :post について' do
      it '関連が正しく設定されていること' do
        association = Favorite.reflect_on_association(:post)
        expect(association.macro).to eq(:belongs_to)
      end
    end
    describe 'belongs_to :user について' do
      it '関連が正しく設定されていること' do
        association = Favorite.reflect_on_association(:user)
        expect(association.macro).to eq(:belongs_to)
      end
    end
  end
end
