Rails.application.routes.draw do
  
  devise_for :users
  
  resources :notes do
    member do
      post :archive
    end
  end
  
  resources :tasks
  
  root to: 'pages#index'
end
