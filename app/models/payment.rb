class Payment < ApplicationRecord
  belongs_to :booking

  enum :status, { pending: 0, completed: 1, failed: 2 }

  PAYMENT_METHODS = %w[cash qr credit_card]

  validates :payment_method, presence: true, inclusion: { in: PAYMENT_METHODS }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :transaction_ref, presence: true, uniqueness: true

  

end