Rails.application.routes.draw do
  devise_for :users

  root to: 'welcome#index'
  resources :welcome, only: [:index]

  resources :users

  resources :portfolios, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :holdings, only: [:index, :create]
  end

  resources :holdings, only: [:show, :edit, :update, :destroy]

  get '/portfolios/:id/grade', to: 'portfolios#grade'

end
