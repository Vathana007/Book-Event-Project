class AddExpiresAtToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :expires_at, :datetime
    add_column :bookings, :cancelled_at, :datetime
  end
end
