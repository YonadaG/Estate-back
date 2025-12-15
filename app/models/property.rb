class Property < ApplicationRecord
  PROPERTY_TYPES = ["House", "Apartment", "Condo", "Townhouse", "Land"].freeze
  STATUSES = ["Available", "Pending", "Sold", "Rented"].freeze

  belongs_to :user
  has_many :images, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :inquirers, through: :inquiries, source: :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :favorited_by_user
  has_many_attached :photos

  validates :title, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 5000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :property_type, presence: true, inclusion: { in: PROPERTY_TYPES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :floor_number, numericality: {
    greater_than_or_equal_to: 0,
    message: "must be 0 or greater(0 =ground floor)"
  }

  scope :active, -> { where(status: "Available") }

  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

  def owned_by?(user)
    user_id == user.id
  end

  def can_be_edited_by?(user)
    user_id == user.id
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def favorites_count
    favorites.count
  end

  def inquiry_from(user)
    inquiries.find_by(user: user)
  end

  def has_inquiries_from?(user)
    inquiries.exists?(user: user)
  end

  def inquiries_count
    inquiries.count
  end

  def pending_inquiries
    inquiries.pending
  end
end
