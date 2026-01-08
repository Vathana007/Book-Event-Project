class AddTicketsToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :tickets, :integer
  end
end
