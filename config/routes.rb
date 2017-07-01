Rails.application.routes.draw do

  resources :users, only: [:new, :create, :show, :destroy] 

  root 'users#new'

  resources :sessions

  resources :trip, only: [:create, :show, :index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
