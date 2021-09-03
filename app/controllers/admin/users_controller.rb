class Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  ROLES = %w[admin manager].freeze

  def index
    @users = User.all

    render json: @users.as_json(only: [:id, :email, :role])
  end

  def token_claims
    {
      aud: ROLES,
      verify_aud: true
    }
  end
end

# config/routes.rb

Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index]
  end
end