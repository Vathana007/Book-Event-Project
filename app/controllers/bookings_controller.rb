class BookingsController < ApplicationController
  before_action :set_event, only: [:new, :create]
  before_action :set_booking, only: [:show]

   # GET /booking
  def index
    if params[:q].present?
      query = params[:q]
      @bookings = Booking.includes(:event)
        .where("CAST(bookings.id AS TEXT) ILIKE ? OR bookings.name ILIKE ?", "%#{query}%", "%#{query}%")
    else
      @bookings = Booking.includes(:event).all
    end
  end

  # GET /booking/:id
  def show
    @booking = Booking.find(params[:id])
  end

  # GET /booking/new
  def new
    @booking = Booking.new
  end

  # GET /booking/:id/edit
  def edit
    @booking = Booking.find(params[:id])
    @event = @booking.event
  end

  # POST /booking
  # def create
  #   @booking = Booking.new(booking_params)
  #   @booking.event = @event
  #   @booking.status = :pending
  #   if @booking.save
  #     @event.decrement!(:available_tickets, @booking.tickets)
  #     redirect_to bookings_path, notice: 'Booking was successfully created.'
  #   else
  #     render :new
  #   end
  # end
  # def create
  #   @booking = Booking.new(booking_params)
  #   @booking.event = @event
  #   @booking.status = :pending
  #   user = User.find(@booking.user_id)
  #   @booking.name = user.name 
  #   total_price = @event.price * @booking.tickets

  #   if user.credit.to_f >= total_price
  #     ActiveRecord::Base.transaction do
  #       @booking.save!
  #       @event.decrement!(:available_tickets, @booking.tickets)
  #       user.update!(credit: user.credit - total_price)
  #     end
  #     redirect_to bookings_path, notice: 'Booking was successfully created and credit deducted.'
  #   else
  #     flash.now[:alert] = "Not enough credit to book this event."
  #     render :new
  #   end
  # end

  def create
    @booking = Booking.new(booking_params)
    @booking.event = @event
    @booking.status = :pending
    user = User.find(@booking.user_id)
    @booking.name = user.name
    @booking.email_address = user.email_address 

    if @booking.save
      redirect_to new_booking_payment_path(@booking)
    else
      render :new
    end
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to bookings_path, notice: 'Booking was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:user_id, :name, :email_address, :phone_number, :tickets)
  end
end