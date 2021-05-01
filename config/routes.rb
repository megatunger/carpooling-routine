Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'

  resources :users, only: [:index]
  resources :locations, only: [:index]

  namespace :modeling do
    get 'pre-processing-lda'
    get 'training-lda', action: 'get_training_lda'
    get 'after-save-routines', action: 'after_save_routines'
    post 'training-lda', action: 'training_lda'
    post 'save-routines-to-db', action: 'save_routines_to_db'
    get 'routes-trip-lda'
  end

  namespace :matching do
    get 'pre-matching', action: 'pre_matching'
    post 'pre-matching-calculate', action: 'pre_matching_calculate'
    get 'live-matching', action: 'live_matching'
  end
end

