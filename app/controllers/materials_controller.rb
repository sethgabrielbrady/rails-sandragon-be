class MaterialsController < ApplicationController
  # before_action :authorize_by_access_header!, only: [:create, :update, :destroy]
  before_action :set_material, only: [:show, :update, :destroy]


  # GET /materials
  def index
    @materials = Material.all
    render json: @materials, methods: [:image_url]
  end

  # GET /materials/1
  def show
    render json: @material, methods: [:image_url]
  end

  # POST /materials/
  def create
    @material = Material.new(material_params)
    attach_pic(@post) if image_params[:image].present?
    if @material.save
      render json: @material, status: :created, location: @material, methods: [:image_url]
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /materials/1
  def update
    attach_pic(@material) if image_params[:image].present?
    @material.falsify_any_active

    if @material.update(material_params)
      render json: @material
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # DELETE /materials/1
  def destroy
    @material.destroy
  end

  private
    def attach_pic(material)
      material.image.attach(image_params[:image])
    end

    def set_material
      @material = Material.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def material_params
      params.require(:material).permit(:title, :description, :blurb, :slug, :active)
    end

    def image_params
      params.permit(:image, :id);
    end
end
