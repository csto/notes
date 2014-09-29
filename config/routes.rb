Rails.application.routes.draw do
  
  get 'users/update'

  get 'users/destroy'

  devise_for :users, controllers: { registrations: 'registrations' }
  
  
  
  resources :users do
    
  end
  
  resources :notes do
    member do
      post :archive
    end
    resources :images, only: [:create]
    resources :user_notes
  end
  
  resources :tasks
  
  resources :images, only: [:destroy]
  
  root to: 'pages#index'
end
