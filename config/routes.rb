Rails.application.routes.draw do
  root 'topics#new'
  resources :topics, only: %i[index show new create]
end
