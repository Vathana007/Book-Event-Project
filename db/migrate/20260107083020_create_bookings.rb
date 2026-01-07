class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone_number
      t.integer :status

      t.timestamps
    end
  end
end
