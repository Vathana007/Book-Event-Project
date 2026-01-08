class AddCreditToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :credit, :decimal
  end
end
