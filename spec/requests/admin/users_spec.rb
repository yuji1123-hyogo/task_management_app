require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:user) { create(:user) }


  describe "GET /admin/users" do
    before do
      sign_in user
    end

    it "ユーザー一覧が表示される" do
      get '/admin/users'
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /users/:id/edit" do
    before do
      sign_in user
    end

    it "編集フォームが表示される" do
      get edit_admin_user_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe "PATCH /users/:id" do
    context 'ログイン済みの場合' do

      before do
        sign_in user
      end

      context "本人のプロフィール更新の場合" do
        context "有効なパラメータの場合" do
          let(:valid_params) do
            {
              name: "更新後の名前"
            }
          end
          it 'プロフィールが更新されること' do
            patch admin_user_path(user), params: { user: valid_params }
            user.reload
            expect(user.name).to eq(valid_params[:name])
          end
        end

        context "無効なパラメータの場合" do
          let(:invalid_params){ { name: "" } }
          it 'プロフィールが更新されないこと' do
            patch admin_user_path(user), params: { user: invalid_params}
            user.reload
            expect(response).to have_http_status(:unprocessable_entity)
            expect(user.name).not_to eq(invalid_params[:name])
          end
        end
      end
    end
  end

  describe "DELETE /users/:id" do
    let(:admin_user) { create(:user, role: :admin) }
    let(:member_user) { create(:user, role: :member) }
    let(:other_user) { create(:user, role: :member) }

    context "管理者の場合" do
      before { sign_in admin_user }

      it '他のユーザーを削除できること' do
        other_user
        expect { 
          delete admin_user_path(other_user) 
        }.to change(User,:count).by(-1)
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in member_user }
      it '他のユーザーを削除できないこと' do
        other_user
        expect { 
          delete admin_user_path(other_user) 
        }.not_to change(User,:count)
      end
    end
  end
end
