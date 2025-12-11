class Image < ApplicationRecord
   belongs_to :property
   belongs_to :uploaded_by, class_name: "User"


   has_one_attached :file
   validates :image_url, presence: true
   validates :file, presence: true, unless: -> { image_url.present? }
   before_validation :set_uploaded_by, on: :create
    def url
    if file.attached?
      Rails.application.routes.url_helpers.url_for(file)
    else
      image_url
    end
  end

  # Get filename
  def filename
    file.filename if file.attached?
  end

  # Get content type
  def content_type
    file.content_type if file.attached?
  end

  # Get file size
  def byte_size
    file.byte_size if file.attached?
  end


   private

   def set_uploaded_by
    self.uploaded_by ||= property.user if property
   end
end
