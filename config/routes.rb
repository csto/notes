Rails.application.routes.draw do
  
  get 'users/update'

  get 'users/destroy'

  devise_for :users
  
  
  
  resources :users do
    resources :user_notes
  end
  
  resources :notes do
    member do
      post :archive
    end
    resources :images, only: [:create]
  end
  
  resources :tasks
  
  resources :images, only: [:destroy]
  
  root to: 'pages#index'
end
