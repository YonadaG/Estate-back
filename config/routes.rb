# config/routes.rb
Rails.application.routes.draw do
   namespace :api do
    namespace :v1 do
  # Authentication routes
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/logged_in", to: "sessions#logged_in"
  post "/signup", to: "sessions#signup"
  # User routes
  resources :users, only: [ :show, :create, :update ]

  # Property routes
  resources :properties, only: [ :index, :show, :create, :update, :destroy ] do
    # Nested image routes for a property
    resources :images, only: [ :index, :create ]

    # Favorite routes for a property
    post "/favorite", to: "favorites#create"
    delete "/favorite", to: "favorites#destroy"
    post "/toggle_favorite", to: "favorites#toggle"
  end

  # Standalone image routes (for update/delete/show)
  resources :images, only: [ :show, :update, :destroy ]

  # Inquiry routes
  resources :inquiries, only: [ :index, :show, :create ] do
    collection do
      get "received"  # GET /inquiries/received
    end
    member do
      put "respond"   # PUT /inquiries/1/respond
      put "close"     # PUT /inquiries/1/close
    end
  end

  # Favorites index route (get all user favorites)
  resources :favorites, only: [ :index ]
end
end
end
