class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true
  validates :status, presence: true
end