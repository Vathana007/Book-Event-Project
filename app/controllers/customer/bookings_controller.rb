class Customer::BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_customer
  before_action :require_customer


  def index
    @bookings = Current.user.bookings.includes(:event, :ticket_type, :payment).order(created_at: :desc)
  end

  def show
    @booking = Current.user.bookings.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = BookingPdf.new(@booking)
        send_data pdf.render, filename: "booking-#{@booking.id}.pdf", type: "application/pdf"
      end
    end
  end

  private

  def ensure_customer
    unless Current.user&.role == "customer"
      redirect_to root_path, alert: "Access denied."
    end
  end

  def authenticate_user!
    unless Current.user
      redirect_to new_session_path, alert: "Please log in to continue."
    end
  end
end