class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  validates :user_id, presence: true
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :status, presence: true
  validates :tickets, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    event.price * tickets
  end
end