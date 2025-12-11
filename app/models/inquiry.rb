class Inquiry < ApplicationRecord
  belongs_to :user
  belongs_to :property
  belongs_to :responded_by, class_name: 'User', optional: true

  validates :message, presence: true, length: { maximum: 2000 }
  validates :status, presence: true, inclusion: { in: %w[pending responded closed] }
  validates :contact_preference, presence: true, inclusion: { in: %w[email phone both] }
  validates :user_id, uniqueness: { scope: :property_id, message: "has already inquired about this property" }
  
  scope :pending, ->{ where(status: 'pending')  }
  scope :responded, ->{ where(status: 'responded') }
  scope :recent, ->{ order(created_at: :desc)}


  


   def pending?
    status =='pending'
   end

   def responded?
    status=='responded'
   end

   def marked_as_responded(responder, response_message)
    update(
      status: 'responded',
      responded_message: response_message,
      responded_by: responder,
    )
   end
    private

    def set_defaults
      self.status ||= 'pending'
      self.contact_preference ||= 'email'
    end


end
