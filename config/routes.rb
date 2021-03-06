Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  get "areas/mapdata" => "areas#mapdata"

  get "places/mapdata" => "places#mapdata"

  resources :areas do
    resources :photos
    resources :videos
    collection { post :import }
  end

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :pages

  root 'pages#globe'

  get '/map' => 'pages#index'

  devise_scope :user do
    get "/sign_in" => "devise/sessions#new"
  end

  resources :users

  resources :places do
    resources :photos
    resources :videos
    resources :discounts
    resources :games
    collection { post :import }
  end

  resources :photos do
    collection { post :import }
  end

  resources :videos do
    collection { post :import }
  end

  resources :games do
    collection { post :import }
  end

  resources :discounts

  match '/send_postcard', to: 'places#send_postcard', via: 'post'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
