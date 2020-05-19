Rails.application.routes.draw do
  post '/api/gps', to: 'waypoints#gps'
end
