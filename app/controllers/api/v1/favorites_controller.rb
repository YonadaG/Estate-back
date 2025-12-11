module Api
  module V1
 
 class FavoritesController < ApplicationController
   before_action :require_login
  before_action :set_property, only: [:create, :destroy, :toggle]
  
  # GET /favorites - Get user's favorite properties
  def index
    @favorites = current_user.favorited_properties.includes(:images, :user)
    render json: @favorites
  end

  # POST /properties/:property_id/favorite - Add to favorites
  def create
    favorite = current_user.favorites.build(property: @property)
    
    if favorite.save
      render json: { 
        message: 'Property added to favorites', 
        favorites_count: @property.favorites_count 
      }, status: :created
    else
      render json: { error: favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /properties/:property_id/favorite - Remove from favorites
  def destroy
    favorite = current_user.favorites.find_by(property: @property)
    
    if favorite&.destroy
      render json: { 
        message: 'Property removed from favorites', 
        favorites_count: @property.favorites_count 
      }
    else
      render json: { error: 'Favorite not found' }, status: :not_found
    end
  end

  # POST /properties/:property_id/toggle_favorite - Toggle favorite status
  def toggle
    if current_user.favorited?(@property)
      current_user.unfavorite(@property)
      render json: { 
        favorited: false, 
        favorites_count: @property.favorites_count 
      }
    else
      current_user.favorite(@property)
      render json: { 
        favorited: true, 
        favorites_count: @property.favorites_count 
      }
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end
 end
  end
end
