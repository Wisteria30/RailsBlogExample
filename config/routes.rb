Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/" => "articles#index"
  get "/new" => "articles#new"
  post "/create" => "articles#create"
  get "/articles/:id" => "articles#show"
  get "/articles/:id/edit" => "articles#edit"
  post "/articles/:id/update" => "articles#update"
  post "/articles/:id/destroy" => "articles#destroy"

  root "home#index"
end
