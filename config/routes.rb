Rails.application.routes.draw do
  get 'members/index'
  devise_for :users
  root to: "tasks#index"
  resources :tasks

  namespace :admin do 
    resources :users
  end
end
