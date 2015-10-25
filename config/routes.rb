Rails.application.routes.draw do

  # Root is the unauthenticated path
  root 'sessions#unauth'

  # Sessions URL
  get 'sessions/unauth', as: :login
  post 'sessions/login', as: :signin
  delete 'sessions/logout', as: :logout


  # Resourceful routes for users
  resources :users, only: [:create, :new, :update, :destroy, :edit]

  # Resourceful routes for articles
  resources :articles, only: [:index, :show]

  # Path for showing interseting articles
  get '/interests', to: 'articles#my_interests', as: :interests

  # Path for calling refresh function to refresh articles
  get '/refresh', to: 'articles#refresh', as: :refresh

  # Path for admins to force a scrape (Pulls new articles and tags them)
  get '/admin/scrape', to: 'admin#scrape', as: :adminscrape

  # Path for admins to send digests to subscribers
  get '/admin/email', to: 'admin#email', as: :adminemail

  # Path for searching
  get '/search/', to: 'articles#search', as: :search


end
