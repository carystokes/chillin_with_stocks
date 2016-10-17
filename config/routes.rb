Rails.application.routes.draw do
  devise_for :users

  root 'portfolios#index'

  resources :portfolios do
    resources :holdings, only: [:index, :create]
  end

  resources :users

  resources :holdings, only: [:edit, :update, :destroy]
  
end
