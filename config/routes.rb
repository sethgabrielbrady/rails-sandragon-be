Rails.application.routes.draw do
  post 'refresh', controller: :refresh, action: :create
  post 'signin', controller: :signin, action: :create
  post 'signup', controller: :signup, action: :create
  delete 'signin', controller: :signin, action: :destroy
  get 'me', controller: :users, action: :me


  resources :posts
  resources :materials
  resources :users,  only: [:show, :update]

  resources :password_resets, only: [:create] do
    collection do
      get ':token', action: :edit, as: :edit
      patch ':token', action: :update
    end
  end

  namespace :api do
    namespace :v1 do
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :update]
  end

end
