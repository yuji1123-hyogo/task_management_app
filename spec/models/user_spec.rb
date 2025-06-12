require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ファクトリーの動作確認' do
    it '有効なファクトリーが作成できる' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '管理者ファクトリーが作成できる' do
      admin = build(:user, :admin)
      expect(admin.role).to eq 'admin'
      expect(admin).to be_valid
    end
  end

  describe 'バリデーション' do
    let(:user) { build(:user) }

    context 'nameについて' do
      it '存在する場合は有効' do
        expect(user).to be_valid
      end

      it '空の場合は無効' do
        user.name = ''
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'emailについて' do
      it '重複している場合は無効' do
        # 最初のユーザーを作成
        create(:user, email: 'test@example.com')
        
        # 同じemailで新しいユーザーを作成
        duplicate_user = build(:user, email: 'test@example.com')
        
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include('はすでに存在します')
      end
    end

    context 'roleについて' do
      it 'memberが設定できる' do
        user.role = :member
        expect(user).to be_valid
        expect(user.member?).to be true
      end

      it 'adminが設定できる' do
        user.role = :admin
        expect(user).to be_valid
        expect(user.admin?).to be true
      end
    end
  end
end
