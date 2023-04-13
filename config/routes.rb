Rails.application.routes.draw do
  root 'topics#new'
  resources :topics do
    resources :suggestions, shallow: true
  end
end
