class UsersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_user, only: [:update]

  def me
    render json: current_user
  end

  def show
    render json: @user
  end

  def update
    attach_pic(@user) if image_params[:image].present?
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def attach_pic(user)
    user.image.attach(image_params[:image])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :terms_of_service, :receive_emails)
  end

  def image_params
    params.permit(:image)
  end
end
