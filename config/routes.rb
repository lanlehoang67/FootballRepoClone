Rails.application.routes.draw do
  root "home#index"

  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/signup", to: "users#create"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  namespace :admin do
    resources :users
    resources :matches
    resources :match_results
    resources :notifications
    resources :leagues
  end
  get "/admin", to: "admin/users#index"
  resources :users
  resources :matches do
    delete "/score_bets", to: "score_bets#destroy"
    get "/score_bets", to: "score_bets#edit"
    patch "/score_bets", to: "score_bets#update"
    post "/score_bets", to: "score_bets#create"
  end
  resources :leagues do
    get "/rankings", to: "leagues#show"
  end
  resources :teams, only: :index
  resources :news do
    resources :comments
  end
end
