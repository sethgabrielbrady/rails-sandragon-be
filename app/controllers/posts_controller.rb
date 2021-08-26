class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.all
    render json: @posts, methods: [:image_url]
  end

  def show
    render json: @post
  end

  def create
    @post = Post.new(post_params)
    attach_main_pic(@post) if image_params[:image].present?
    if @post.save
      render json: @post, status: :created, location: @post, methods: [:image_url]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    attach_main_pic(@post) if image_params[:image].present?
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private
    def attach_main_pic(post)
      post.image.attach(post_params[:image])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :author, :body)
    end

    def image_params
      params.permit(:image, :id)
    end
end
