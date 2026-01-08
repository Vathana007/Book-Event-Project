class AddEmailAddressToBookings < ActiveRecord::Migration[8.1]
  def change
    add_column :bookings, :email_address, :string
  end
end
