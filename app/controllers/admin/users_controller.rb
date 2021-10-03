class Admin::UsersController < ApplicationController
  before_action :authorize_access_request!
  ROLES = %w[admin].freeze

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

  private

    def allowed_aud
      action_name == 'update' ? EDIT_ROLES : VIEW_ROLES
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end
end
