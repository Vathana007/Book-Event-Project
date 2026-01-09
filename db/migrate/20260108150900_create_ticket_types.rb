class CreateTicketTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :ticket_types do |t|
      t.string :name
      t.decimal :price
      t.integer :available_tickets
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
