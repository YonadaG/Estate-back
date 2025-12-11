class InquiriesController < ApplicationController
  before_action :require_login
  before_action :set_inquiry, only: [ :show, :respond, :close ]


  def index
    @inquiries =current_user.set_inquiries.includes(:property, :responded_by)
    render json: @inquiries
  end
  def received
    unless current_user.owner? || current_user.broker?|| current_user.admin?
      render json: { error: "Access denied" }, status: :forbidden
      return
    end
    @inquiries= current_user.received_inquiries.includes(:user, :property)
    render json: @inquiries
  end
 def show
   unless @inquiry.user == current_user || @inquiries.property.user ==current_user
     render json: { error: "Access denied" }, status: :forbidden
     return
   end
    render json: @inquiry, include: [ :user, :property, :responded_by ]
 end
 def create
   @property = Property.find(params[:property_id])
   @inquiry =current_user.inquiries.bulid(
    property: @property,
    message: params[:message],
    contact_preference: params[:contact_preference]|| "email"
   )
   if @inquiry.save
      render json: {
        message: "Inquiry sent successfully",
        inquiry: @inquiry
      }, status: :created
   else
      render json: { errors: @inquiry.errors.full_messages }, status: :unprocessable_entity
   end
end
def respond
    # Check if current user can respond (owns the property or is admin)
    unless @inquiry.can_respond?(current_user)
      render json: { error: "Not authorized to respond to this inquiry" }, status: :forbidden
      return
    end

    if @inquiry.mark_as_responded(current_user, params[:response_message])
      render json: {
        message: "Response sent successfully",
        inquiry: @inquiry
      }
    else
      render json: { errors: @inquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /inquiries/:id/close - Close an inquiry
  def close
    # Only property owner or inquiry sender can close
    unless @inquiry.property.user == current_user || @inquiry.user == current_user
      render json: { error: "Not authorized" }, status: :forbidden
      return
    end

    if @inquiry.mark_as_closed
      render json: { message: "Inquiry closed", inquiry: @inquiry }
    else
      render json: { errors: @inquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end
end
