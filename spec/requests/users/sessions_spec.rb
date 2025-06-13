require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "works! (now write some real specs)" do
      get new_user_sessions_path
      expect(response).to have_http_status(200)
    end
  end
end
