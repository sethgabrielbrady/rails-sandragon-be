class MaterialsController < ApplicationController
  # before_action :authorize_access_request!, only: [:create, :update, :destroy]
  before_action :set_material, only: [:show, :update, :destroy]
  EDIT_ROLES = %w[admin].freeze
  VIEW_ROLES = %w[admin].freeze

  # GET /materials
  def index
    @materials = Material.all
    render json: @materials, methods: [:image_url, :file_url]
    # render json: @materials, methods: [:image_url, :file_url]
  end

  # GET /materials/1
  def show
    render json: @material, methods: [:image_url, :file_url]
    # render json: @material, methods: [:image_url, :file_url]
  end

  # POST /materials/
  def create
    @material = Material.new(material_params)
    attach_pic(@material) if image_params[:image].present?
    attach_file(@material) if file_params[:file].present?
    if @material.save
      # render json: @material, status: :created, location: @material, methods: [:image_url]
      render json: @material, status: :created, location: @material, methods: [:image_url, :file_url]
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /materials/1
  def update
    attach_file(@material) if file_params[:file].present?
    attach_pic(@material) if image_params[:image].present?
    # @material.falsify_any_active

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

  def token_claims
    {
      aud: allowed_aud,
      verify_aud: true
    }
  end

  private

    def allowed_aud
      action_name == 'update' ?  EDIT_ROLES : VIEW_ROLES
    end

    def attach_pic(material)
      material.image.attach(image_params[:image])
    end

    def attach_file(material)
      material.file.attach(file_params[:file])
    end

    def set_material
      @material = Material.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def material_params
      params.require(:material).permit(:title, :description, :blurb, :slug, :active, :id)
    end

    def image_params
      params.permit(:image);
    end

    def file_params
      params.permit(:file);
    end
end
