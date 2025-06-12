FactoryBot.define do
  factory :user do
    name { "テスト太郎" }
    email { "test@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :member }  # enumの初期値
  end
end
