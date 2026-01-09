require 'prawn'
require 'prawn/table'

class BookingsPdf
  include Prawn::View

  def initialize(bookings)
    @bookings = bookings
    header
    table_content
  end

  def header
    text "Bookings Report", size: 24, style: :bold, align: :center
    move_down 20
  end

  def table_content
    table booking_rows, header: true, width: bounds.width do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
    end
  end

  def booking_rows
    [["ID", "User", "Event", "Created At"]] +
      @bookings.map do |b|
        [b.id, b.user_id, b.event_id, b.created_at.strftime("%Y-%m-%d %H:%M")]
      end
  end
end