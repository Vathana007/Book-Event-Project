class RemovePriceAndAvailableTicketsFromEvents < ActiveRecord::Migration[8.1]
  def change
    remove_column :events, :price, :decimal
    remove_column :events, :available_tickets, :integer
  end
end
