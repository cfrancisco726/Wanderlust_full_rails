Rails.application.routes.draw do


  root 'trip#new'

  resources :sessions

  resources :trip, only: [:create, :show, :index]

  # get '/users/logout' to: 'users#logout'
  # post '/users/login' to: 'users#create_session'
  get '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  post '/users/login', to: 'users#create_session'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
