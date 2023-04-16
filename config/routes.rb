Rails.application.routes.draw do
  root 'topics#new'
  resources :topics do
    resources :suggestions, shallow: true do
      member do
        get :image
      end
    end
  end
end
