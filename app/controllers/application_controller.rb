class ApplicationController < ActionController::Base
  before_action :set_current_user
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_admin
    unless Current.user&.role == "admin"
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_customer
    unless Current.user&.role == "customer"
      redirect_to root_path, alert: "Access denied."
    end
  end
end
