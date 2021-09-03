Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
    end
  end

  resources :posts
  resources :materials
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy
end
