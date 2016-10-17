Rails.application.routes.draw do
  devise_for :users

  root 'portfolios#index'

  resources :users
  
  resources :portfolios, only: [:index, :show, :new, :create, :destroy] do
    resources :holdings, only: [:index, :create]
  end

  resources :holdings, only: [:edit, :update, :destroy]

end
