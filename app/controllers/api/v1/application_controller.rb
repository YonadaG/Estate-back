module Api
  module V1
class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # If you don't have a gem that defines `allow_browser`, remove or uncomment this line.
  # allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  # Get the currently logged in user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Check if user is logged in
  def logged_in?
    !!current_user
  end

  # Require user to be logged in for certain actions
  def require_login
    unless logged_in?
      render json: { error: "Please log in" }, status: :unauthorized
    end
  end
end
  end 
end