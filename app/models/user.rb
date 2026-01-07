class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[admin customer] }
  validates :phone_number, presence: true, uniqueness: true
end
