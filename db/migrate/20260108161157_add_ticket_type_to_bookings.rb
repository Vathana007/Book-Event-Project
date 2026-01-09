class AddTicketTypeToBookings < ActiveRecord::Migration[8.1]
  def change
    add_reference :bookings, :ticket_type, null: true, foreign_key: true
  end
end
