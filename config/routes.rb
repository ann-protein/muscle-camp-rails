Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/muscle_posts', to: "muscle_posts#timeline"
  get '/muscle_posts/:id', to: "muscle_posts#get_muscle_post"
  post '/muscle_posts', to: "muscle_posts#create_muscle_post"


  delete '/users', to: "users#destroy"
  post '/users/login', to: "users#login"
  resources :users, only: [:create, :edit, :update] , param: :identity
  get '/users/:identity',    to: "users#get_user_data"
end