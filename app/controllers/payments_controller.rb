class PaymentsController < ApplicationController
  before_action :set_booking

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.booking = @booking
    @payment.amount = @booking.event.price * @booking.tickets
    @payment.status = :completed
    @payment.transaction_ref = SecureRandom.hex(10)
    user = @booking.user

    if @payment.payment_method == "credit_card"
    total_price = @booking.event.price * @booking.tickets
      if user.credit.to_f >= total_price
        ActiveRecord::Base.transaction do
          user.update!(credit: user.credit - total_price)
          @booking.event.decrement!(:available_tickets, @booking.tickets)
          @booking.update!(status: :confirmed)
          @payment.save!
        end
        redirect_to booking_path(@booking), notice: "Payment successful and credit deducted!"
      else
        flash.now[:alert] = "Not enough credit."
        render :new
      end
    else
      # Handle other payment methods (e.g., cash, card)
      ActiveRecord::Base.transaction do
        @booking.event.decrement!(:available_tickets, @booking.tickets)
        @booking.update!(status: :confirmed)
        @payment.save!
      end
      redirect_to booking_path(@booking), notice: "Payment successful!"
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