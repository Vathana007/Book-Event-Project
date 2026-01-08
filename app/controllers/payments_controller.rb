class PaymentsController < ApplicationController
  before_action :set_booking

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.booking = @booking
    @payment.amount = @booking.event.price
    @payment.status = :completed
    @payment.transaction_ref = SecureRandom.hex(10)
    if @payment.save
      @booking.update(status: :confirmed)
      redirect_to events_path, notice: "Payment successful!"
    else
      render :new
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_method)
  end
end