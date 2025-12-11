class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :user_id, uniqueness: { scope: :property_id, message: "has already favorited this property" }

  def self.favorited?(user, property)
    return false unless user && property
    exists?(user_id: user.id, property_id: property.id)
  end

  # Toggle favorite: returns true if created, false if destroyed, nil if invalid args
  def self.toggle_favorite(user, property)
    return nil unless user && property

    favourite = find_by(user_id: user.id, property_id: property.id)
    if favourite
      favourite.destroy
      false
    else
      create!(user: user, property: property)
      true
    end
  end
end
