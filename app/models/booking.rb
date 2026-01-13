require 'csv'

class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :ticket_type
  has_one :payment

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  validates :user_id, presence: true
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :status, presence: true
  validates :tickets, presence: true, numericality: { greater_than: 0 }
  validate :tickets_available, on: :create

  after_create_commit :broadcast_booking

  def tickets_available
    if ticket_type && tickets > ticket_type.available_tickets
      errors.add(:tickets, "exceeds available tickets")
    end
  end

  # def total_price
  #   ticket_type.price * tickets
  # end

  def total_price
    ticket_type&.price.to_f * tickets.to_i
  end

  def self.to_csv
    attributes = %w{id user_id event_id created_at updated_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |booking|
        csv << attributes.map { |attr| booking.send(attr) }
      end
    end
  end

  private

  def broadcast_booking
    broadcast_prepend_later_to "bookings", target: "bookings_table", partial: "bookings/booking_row", locals: { booking: self }
  end

end