Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'

  resources :users, only: [:index]
  resources :locations, only: [:index]

  namespace :modeling do
    get 'pre-processing-lda'
    get 'training-lda'
  end
end

