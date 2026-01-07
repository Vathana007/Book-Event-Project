class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :payment_method
      t.decimal :amount
      t.integer :status
      t.string :transaction_ref

      t.timestamps
    end
  end
end
