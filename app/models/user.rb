class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create
  validates :password, confirmation: true, allow_blank: true, on: :update
  validates :credit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :role, presence: true, inclusion: { in: %w[admin customer] }
  validates :phone_number, presence: true, uniqueness: true
end
