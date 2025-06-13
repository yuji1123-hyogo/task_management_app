require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/registrations" do
    it "サインアップページが表示される" do
      get new_user_registration_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POst /users" do 
    context "有効なパラメータの場合" do
      let(:valid_params){ 
        {
          name: "username",
          email: "newuser@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
      it "新しいユーザーが作成される" do
        expect {
          post user_registration_path, params: { user: valid_params }
      }.to change(User, :count).by(1)
      end

      it "作成されたユーザーのメールアドレスが正しい" do
        post user_registration_path, params: { user: valid_params }

        created_user = User.find_by( email: valid_params[:email] )
        expect(created_user).to be_present
      end
    end

    context "無効なパラメータの場合" do
      let(:invalid_params){
        {
          email: "",
          password: "",
          password_confirmation: "a"
        }
      }
      it "ユーザーが作成されない" do
        expect{
          post user_registration_path, params: { user: invalid_params}
        }.not_to change( User, :count )

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
