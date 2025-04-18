Rails.application.routes.draw do
  resources :posts, only: [:create] do
    collection do
      get :top
      get :ips
    end
  end

  resources :ratings, only: [:create]
end
