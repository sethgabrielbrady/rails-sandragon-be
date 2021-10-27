class PostsController < ApplicationController
  # before_action :authorize_access_request!, only: [:update, :destroy]
  # ROLES = %w[admin].freeze
  before_action :set_post, only: [:show, :update, :destroy]
  # before_action :set_post, only: [:show]

  def index
    @posts = Post.all
    render json: @posts, methods: [:image_url]
  end

  def show
    render json: @post, methods: [:image_url]
  end

  def create
    @post = Post.new(post_params)
    attach_pic(@post) if image_params[:image].present?
    if @post.save
      render json: @post, status: :created, location: @post, methods: [:image_url]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    attach_pic(@post) if image_params[:image].present?
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end
  # def token_claims
  #   {
  #     aud: ROLES,
  #     verify_aud: true
  #   }
  # end
  private
    def attach_pic(post)
      post.image.attach(image_params[:image])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :author, :body, :blurb)
    end

    def image_params
      params.permit(:image)
    end

end
