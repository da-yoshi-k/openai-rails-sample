Rails.application.routes.draw do
  root 'topics#new'
  resources :topics, only: %i[show new create]
end
