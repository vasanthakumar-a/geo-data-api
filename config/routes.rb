Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post '/login', to: 'users/sessions#create'
    post '/register', to: 'users/registrations#create'
    post '/logout', to: 'users/sessions#logout'
  end

  resources :geospatial_data
  resources :shapes
end
