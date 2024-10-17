Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post '/login', to: 'users/sessions#create'
    post '/register', to: 'users/registrations#create'
    delete '/logout', to: 'users/sessions#destroy'
  end
end
