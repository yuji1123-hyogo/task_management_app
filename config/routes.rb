Rails.application.routes.draw do
  get 'members/index'
  devise_for :users
  root to: "tasks#index"
  resources :tasks
  resources :posts, shallow: true do
    resources :comments, only: [:create, :destroy]
  end

  namespace :admin do 
    resources :users
  end
end
