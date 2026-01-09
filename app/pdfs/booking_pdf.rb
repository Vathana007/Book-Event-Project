require 'prawn'
require 'prawn/table'

class BookingPdf
  def initialize(booking)
    @booking = booking
    @pdf = Prawn::Document.new
    header
    details
  end

  def header
    @pdf.text "Booking ##{@booking.id}", size: 24, style: :bold
    @pdf.move_down 10
    @pdf.text "Created: #{@booking.created_at.strftime("%B %d, %Y at %I:%M %p")}"
    @pdf.move_down 20
  end

  def details
    @pdf.text "Event: #{@booking.event.title}", style: :bold
    @pdf.text "Location: #{@booking.event.location}"
    @pdf.text "Date: #{@booking.event.start_time.strftime("%B %d, %Y at %I:%M %p")}"
    @pdf.move_down 10

    @pdf.text "Customer: #{@booking.name}"
    @pdf.text "Email: #{@booking.email_address}"
    @pdf.text "Phone: #{@booking.phone_number || 'Not provided'}"
    @pdf.move_down 10

    @pdf.text "Ticket Type: #{@booking.ticket_type.name}"
    @pdf.text "Number of Tickets: #{@booking.tickets}"
    @pdf.text "Price per Ticket: #{ApplicationController.helpers.number_to_currency(@booking.ticket_type.price)}"
    @pdf.text "Total Amount: #{ApplicationController.helpers.number_to_currency(@booking.total_price)}"
    @pdf.move_down 10

    if @booking.payment
      @pdf.text "Payment Method: #{@booking.payment.payment_method.titleize}"
      @pdf.text "Transaction Reference: #{@booking.payment.transaction_ref}"
      @pdf.text "Payment Status: #{@booking.payment.status.titleize}"
      @pdf.text "Payment Date: #{@booking.payment.created_at.strftime("%B %d, %Y at %I:%M %p")}"
    else
      @pdf.text "Payment: Pending"
    end
  end

  def render
    @pdf.render
  end
end