Rails.application.routes.draw do


  root 'trip#new'

  resources :sessions

  resources :trip, only: [:create, :show, :index]

  # get '/users/logout' to: 'users#logout'
  # post '/users/login' to: 'users#create_session'
  get '/trip/:trip_id/locations/:location', to: 'trip#google_place'
  get '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  get '/users/:flight_id/savetrip', to: 'users#save_trip'
  post '/users/login', to: 'users#create_session'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
