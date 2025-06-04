Rails.application.routes.draw do
  namespace :admin do
    get 'users/new'
  end
  root to: "tasks#index"
  resources :tasks

  namespace :admin do 
    resources :users
  end
end
