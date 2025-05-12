Rails.application.routes.draw do
  post '/posts/batch', to: 'posts#batch_create'
  
  resources :posts, only: [:create] do
    collection do
      get :top
      get :ips
    end
  end

  resources :ratings, only: [:create]
end
