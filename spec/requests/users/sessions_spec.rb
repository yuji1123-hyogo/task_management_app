require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  let(:user) { create(:user) }
  describe "GET /users/sign_in" do
    it "ログインページが表示される" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users/sign_in" do 
    context "正しい認証情報の場合" do
      let(:validate_credentials) do
        {
          email: user.email,
          password: user.password
        }
      end
      it "ログインが成功する" do
        post user_session_path, params: {user: validate_credentials}

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "ログイン後に認証が必要なページにアクセスできる" do
        post user_session_path, params: { user: validate_credentials }
        
        get '/posts'
        expect(response).to have_http_status(:ok)
      end
    end

    context "間違った認証情報の場合" do 
      let(:invalid_credentials) do 
        {
          email: user.email,
          password: "wrongpassword"
        }
      end

      it "ログインが失敗する" do 
        post user_session_path, params: { user:invalid_credentials }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe "DELETE /users/sign_out" do 
    let(:user) { create(:user) }

    context "ログイン済みの場合" do
      before {
        post user_session_path, params: {
          email: user.email,
          password: user.password
        }
      }
      it "ログアウトが成功する" do 
        delete destroy_user_session_path

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end

      it "ログアウト後は認証が必要なページにアクセスできない" do
        delete destroy_user_session_path
        get '/posts'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do 
        delete destroy_user_session_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
