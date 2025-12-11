module Api
  module V1

class ImagesController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_image, only: [ :show, :update, :destroy ]
  before_action :set_property, only: [ :create ]

  # GET /properties/:property_id/images
  def index
    @property = Property.find(params[:property_id])
    @images = @property.images
    render json: @images
  end

  # GET /images/:id
  def show
    render json: @image
  end

  # POST /properties/:property_id/images
  # def create
  #   # Only property owner or admin can add images
  #   unless @property.can_be_edited_by?(current_user)
  #     render json: { error: 'Not authorized to add images to this property' }, status: :forbidden
  #     return
  #   end

  #   @image = @property.images.build(image_params.merge(uploaded_by: current_user))

  #   if @image.save
  #     render json: @image, status: :created
  #   else
  #     render json: { errors: @image.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end
  def create
    unless @property.can_be_edited_by?(current_user)
      render json: { error: "Not authorized to add images to this property" }, status: :forbidden
      return
    end

    @image = @property.images.new(uploaded_by: current_user)
    @image.file.attach(params[:file])

    if @image.save
      render json: {
        image: @image.as_json(methods: [ :url, :filename, :content_type, :byte_size ]),
        message: "Image uploaded successfully"
      }, status: :created
    else
      render json: { errors: @image.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /images/:id
  def update
    # Only property owner or admin can update images
    unless @image.property.can_be_edited_by?(current_user)
      render json: { error: "Not authorized to update this image" }, status: :forbidden
      return
    end

    if @image.update(image_params)
      render json: @image
    else
      render json: { errors: @image.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /images/:id
  def destroy
    @image = Image.find(params[:id])

    unless @image.property.can_be_edited_by?(current_user)
      render json: { error: "Not authorized to delete this image" }, status: :forbidden
      return
    end

    @image.destroy
    render json: { message: "Image deleted successfully" }
  end

  private

  def set_image
    @image = Image.find(params[:id])
  end

  def set_property
    @property = Property.find(params[:property_id])
  end

  def image_params
    params.require(:image).permit(:url, :alt_text, :is_primary)
  end
end
  end
end
