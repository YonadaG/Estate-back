class User < ApplicationRecord
    has_secure_password
    Roles = [ "admin", "owner", "broker", "user" ].freeze
    has_many :inquiries, dependent: :destroy
    has_many :inquiry_responses, class_name: "Inquiry", foreign_key: "responded_by_id"
    has_many :properties, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorited_properties, through: :favorites, source: :property



    # Validations

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :phone, presence: true
    validates :role, presence: true, inclusion: { in: Roles }


    def admin?
        role=="admin"
    end
    def owner?
        role=="owner"
    end
    def broker?
        role=="broker"
    end
    def user?
        role=="user"
    end

    def can_create_property?
        owner? || broker? || admin?
    end

    def can_manage_users?
        admin?
    end

     def favorite(property)
        favorites.create(property: property) unless favorited?(property)
     end
     def unfavorite(property)
        favorites.where(property: property).destroy_all
     end
    def favorited?(property)
        favorites.exists?(property: property)
    end
    def favorited_properties_count
        favorites.count
    end

     def sent_inquiries
        inquires.includes(:property)
     end

     def received_inquiries
        Inquiry.for_property_owner(self).includes(:user, :property)
     end

    def pending_inquiries_count
         received_inquiries.pending.count
    end





  # this is the end
end
