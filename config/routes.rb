Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/muscle_posts', to: "muscle_posts#timeline"

  post '/users/login',    to: "users#login"

  resources :users, only: [:create, :edit, :update, :destroy]
  get '/users/:id',    to: "users#get_user_data"
end