require 'sidekiq/web'

Rails.application.routes.draw do
  post '/api/gps', to: 'waypoints#gps'
  get 'show', to: 'maps#show'

  mount Sidekiq::Web => '/sidekiq'
end
