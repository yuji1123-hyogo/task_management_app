Rails.application.routes.draw do
  root to: "tasks#index"
  get 'members/index'
  get 'tags/:name', to: 'tags#show', as: :tag

  devise_for :users

  resources :events do
    resources :tickets, only: [:create, :destroy]
  end
  resources :tasks
  resources :posts, shallow: true do
    resources :comments, only: [:create, :destroy]
  end
  namespace :admin do 
    resources :users
  end
end
