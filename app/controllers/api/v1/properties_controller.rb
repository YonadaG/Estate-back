module Api
  module V1
class PropertiesController < ApplicationController
  before_action :require_login, only: [ :create, :destroy ]
  before_action :set_property, only: [ :show, :destroy, :update ]

  def index
    @properties = Property.active.includes(:user, :images)
    @properties = @properties.by_property_type(params[:property_type]) if params[:property_type].present?
    @properties = @properties.by_city(params[:city]) if params[:city].present?

    if params[:min_price].present? && params[:max_price].present?
      min_price = params[:min_price].presence || 20_000
      max_price = params[:max_price].presence || 10_000_000
      @properties = @properties.by_price_range(min_price, max_price)
    end

    render json: @properties
  end

  def show
    render json: @property, include: [ :user, :images ]
  end

  def create
    unless current_user.can_create_property?
      render json: { errors: "only owners and brokers can create properties" }, status: :forbidden
      return
    end

    @property = current_user.properties.build(property_params)

    if @property.save
      render json: { property_title: @property.title, photo_url: [
        @property.photos.map { |photo| url_for(photo) }
      ]}, status: :created
    else
      render json: { errors: @property.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
      unless @property.can_be_edited_by?(current_user)
        render json: { error: "NOT authorized to update this property" }, status: :forbidden
        return
      end

      if @property.update(property_params)
        # Handle new image uploads
        render json: @property.as_json(include: {
          images: {
            methods: [ :url, :filename, :content_type, :byte_size ]
          }
        })
      else
        render json: { errors: @property.errors.full_messages }, status: :unprocessable_entity
      end
  end
  def destroy
    unless @property.can_be_edited_by?(current_user) || current_user.admin?
      render json: { error: "NOT authorized to delete this property" }, status: :forbidden
      return
    end

    @property.destroy
    render json: { message: "Property deleted successfully" }
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(
      :title, :description, :price, :property_type,
      :location, :bedrooms, :area, :status, :bathrooms, :floor_number,
      additional_information: {},
      photos: []
    )
  end
# D:\projects\rails\estate-back\storage\4q\b3\4qb3o43lguzbwjui25c5xzlnf60q
  def render_not_found
    render json: { error: "Property not found" }, status: :not_found
  end
end
  end
end