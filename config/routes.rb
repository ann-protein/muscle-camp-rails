Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/muscle_posts', to: "muscle_posts#timeline"
  get '/muscle_posts/:id', to: "muscle_posts#getpost"
end