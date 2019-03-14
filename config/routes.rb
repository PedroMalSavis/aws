Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get 'home/test'
  resources :services
  resources :products
  resources :posts
  resources :transactions
  resources :users
end
