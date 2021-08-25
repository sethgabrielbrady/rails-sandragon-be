class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all
    render json: @posts, methods: [:image_url]
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    attach_main_pic(@post) if post_params[:image].present?
    if @post.save
      render json: @post, status: :created, location: @post, methods: [:image_url]
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    raise params.inspect
    attach_main_pic(@post) if post_params[:image].present?
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    set_post
    @post.destroy
  end

  private
    def attach_main_pic(post)
      post.image.attach(post_params[:image])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :image, :author, :body)
    end
end
