class Event < ApplicationRecord
  belongs_to :category
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  has_many :ticket_types, dependent: :destroy

  has_one_attached :image

  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :available_tickets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :start_time, presence: true
  validates :end_time, presence: true
end