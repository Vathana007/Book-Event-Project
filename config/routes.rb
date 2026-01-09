Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resource :registration, only: [:new, :create]
  resources :passwords, param: :token
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :customer do
    resources :events, only: [:index, :show]
    resources :bookings, only: [:index, :show]
  end

  resources :categories

  # Events and Bookings nested routes
  resources :events do
    resources :bookings, only: [:new, :create, :show]
  end

  # Payments and Bookings nested routes
  resources :bookings, only: [:index, :show, :edit, :update] do
    resources :payments, only: [:new, :create]
    collection do
      get :export  
    end

  end

  # Ticket Types and Bookings nested routes
  resources :events do
    resources :ticket_types do
      resources :bookings, only: [:new, :create]
    end
  end

  # resource :customer_dashboard, only: [:index]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "events#index"
end
