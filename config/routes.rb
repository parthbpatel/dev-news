Rails.application.routes.draw do
  root 'links#index'

  resources :links, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
    get :upvote, on: :member
    get :downvote, on: :member
  end

  get '/comments', to: 'comments#index'
  get '/newest', to: 'links#newest'

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :users, only: [:new, :create]
end
