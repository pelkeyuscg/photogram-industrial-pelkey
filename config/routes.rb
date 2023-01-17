Rails.application.routes.draw do
  root "photos#index"

  devise_for :users

  resources :comments  
  resources :follow_requests
  resources :likes
  resources :photos
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
