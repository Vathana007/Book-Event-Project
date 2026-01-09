class PaymentsController < ApplicationController
  before_action :set_booking
  

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.booking = @booking
    @payment.amount = @booking.ticket_type.price * @booking.tickets
    @payment.transaction_ref = SecureRandom.hex(10)
    user = @booking.user

    ActiveRecord::Base.transaction do
      if @payment.payment_method == "credit_card"
        total_price = @booking.ticket_type.price * @booking.tickets
        
        if user.credit.to_f >= total_price
          # Deduct credit
          user.update!(credit: user.credit - total_price)
          
          # Confirm booking and payment
          @booking.update!(status: :confirmed)
          @payment.status = :completed
          @payment.save!
          
          redirect_to booking_path(@booking), notice: "Payment successful and credit deducted!"
        else
          # Not enough credit - release tickets and cancel booking
          @booking.ticket_type.increment!(:available_tickets, @booking.tickets)
          @booking.update!(status: :cancelled)
          
          flash.now[:alert] = "Not enough credit. Your booking has been cancelled and tickets released."
          render :new
        end
      else
        # Handle other payment methods (cash, card, etc.)
        @booking.update!(status: :confirmed)
        @payment.status = :completed
        @payment.save!
        
        redirect_to booking_path(@booking), notice: "Payment successful!"
      end
    end
  rescue => e
    # On any error, release tickets
    @booking.ticket_type.increment!(:available_tickets, @booking.tickets)
    @booking.update(status: :cancelled)
    flash.now[:alert] = "Payment failed: #{e.message}"
    render :new
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_method)
  end
end