Rails.application.routes.draw do
  root 'links#index'

  resources :links do
    resources :comments, only: %i[create edit update destroy]

    member do
      post :upvote
      post :downvote
    end
  end

  get '/comments', to: 'comments#index'
  get '/newest', to: 'links#newest'

  resource :session, only: %i[new create destroy]
  resources :users, only: [:new, :create]
end
