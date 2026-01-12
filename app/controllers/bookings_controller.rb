require 'csv'

class BookingsController < ApplicationController
  before_action :set_event, only: [:new, :create]
  before_action :set_booking, only: [:show]
  before_action :require_admin, except: [:index, :show, :new, :create]

   # GET /booking
  def index
    if Current.user&.role == "admin"
      # Admin sees all bookings
      if params[:q].present?
        query = params[:q]
        @bookings = Booking.includes(:event)
          .where("CAST(bookings.id AS TEXT) ILIKE ? OR bookings.name ILIKE ?", "%#{query}%", "%#{query}%")
      else
        @bookings = Booking.includes(:event).all
      end
    else
      # Customer sees only their own bookings
      if params[:q].present?
        query = params[:q]
        @bookings = Booking.includes(:event)
          .where(user_id: Current.user.id)
          .where("CAST(bookings.id AS TEXT) ILIKE ? OR bookings.name ILIKE ?", "%#{query}%", "%#{query}%")
      else
        @bookings = Booking.includes(:event).where(user_id: Current.user.id)
      end
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
  def create
    @booking = Booking.new(booking_params)
    @booking.event = @event
    @booking.status = :pending

    # Find or create user based on email
    user = User.find_or_create_by(email_address: @booking.email_address) do |u|
      u.name = @booking.name
      u.phone_number = @booking.phone_number
      u.role = 'customer'
      u.password = SecureRandom.hex(10) # Generate random password for new users
      u.credit = 0
    end

    @booking.user = user

    ticket_type = TicketType.find(@booking.ticket_type_id)

    ActiveRecord::Base.transaction do
      # Lock the ticket type row to prevent race conditions
      ticket_type.lock!
      
      # Check if enough tickets are available
      if ticket_type.available_tickets < @booking.tickets
        flash.now[:alert] = "Not enough tickets available. Only #{ticket_type.available_tickets} tickets left."
        render :new and return
      end
      
      # Reserve tickets immediately
      ticket_type.decrement!(:available_tickets, @booking.tickets)
      
      # Save booking
      if @booking.save
        redirect_to new_booking_payment_path(@booking)
      else
        # If booking fails, release the tickets
        ticket_type.increment!(:available_tickets, @booking.tickets)
        render :new
      end 
    end
  rescue ActiveRecord::RecordNotFound
    flash.now[:alert] = "Invalid ticket type selected."
    render :new
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to bookings_path, notice: 'Booking was successfully updated.'
    else
      render :edit
    end
  end

  def export
    @bookings = Booking.all

    respond_to do |format|
      format.csv do
        send_data @bookings.to_csv, filename: "bookings-#{Date.today}.csv"
      end
      format.pdf do
        pdf = BookingsPdf.new(@bookings)
        send_data pdf.render, filename: "bookings-#{Date.today}.pdf", type: "application/pdf"
      end
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
    params.require(:booking).permit(:name, :email_address, :phone_number, :ticket_type_id, :tickets)
  end
end

# class BookingsController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_event, only: [:new, :create]

#   # GET /booking
#   def index
#     if params[:q].present?
#       query = params[:q]
#       @bookings = Booking.includes(:event)
#         .where("CAST(bookings.id AS TEXT) ILIKE ? OR bookings.name ILIKE ?", "%#{query}%", "%#{query}%")
#     else
#       @bookings = Booking.includes(:event).all
#     end
#   end

#   # GET /booking/:id
#   def show
#     @booking = Booking.find(params[:id])
#   end

#   # GET /booking/new
#   def new
#     @booking = Booking.new
#   end

#   # GET /booking/:id/edit
#   def edit
#     @booking = Booking.find(params[:id])
#     @event = @booking.event
#   end

#   def create
#     @booking = Booking.new(booking_params)
#     @booking.event = @event
#     @booking.user = Current.user
#     @booking.name = Current.user.name
#     @booking.email_address = Current.user.email_address
#     @booking.phone_number = Current.user.phone_number
#     @booking.status = :pending

#     ticket_type = TicketType.find(@booking.ticket_type_id)

#     ActiveRecord::Base.transaction do
#       ticket_type.lock!
      
#       if ticket_type.available_tickets < @booking.tickets
#         flash.now[:alert] = "Not enough tickets available. Only #{ticket_type.available_tickets} tickets left."
#         render :new and return
#       end
      
#       ticket_type.decrement!(:available_tickets, @booking.tickets)
      
#       if @booking.save
#         redirect_to new_booking_payment_path(@booking), notice: "Booking created! Please complete payment."
#       else
#         ticket_type.increment!(:available_tickets, @booking.tickets)
#         render :new
#       end
#     end
#   rescue ActiveRecord::RecordNotFound
#     flash.now[:alert] = "Invalid ticket type selected."
#     render :new
#   end

#   def update
#     @booking = Booking.find(params[:id])
#     if @booking.update(booking_params)
#       redirect_to bookings_path, notice: 'Booking was successfully updated.'
#     else
#       render :edit
#     end
#   end

#   private

#   def set_event
#     @event = Event.find(params[:event_id])
#   end

#   def set_booking
#     @booking = Booking.find(params[:id])
#   end

#   def booking_params
#     params.require(:booking).permit(:ticket_type_id, :tickets)
#   end
# end