Rails.application.routes.draw do
  devise_for :users
  resources :users

  get '/team', to: 'users#team', as: 'team'
  get '/custodians', to: 'users#custodians', as: 'custodians'

  devise_scope :user do
    authenticated :user do
      root to: 'home#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  post 'select_register', to: "home#select_register"

  get '/:register', to: 'register#index'
  get '/:register/:id/edit', to: 'register#edit'
  get '/:register/new', to: 'register#new'
  post '/:register', to: 'register#create'

end
