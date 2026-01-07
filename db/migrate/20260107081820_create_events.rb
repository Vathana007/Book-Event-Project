class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :location
      t.decimal :price, precision: 10, scale: 2
      t.integer :available_tickets
      t.datetime :start_time
      t.datetime :end_time
      t.string :image
      t.references :category, null: false, foreign_key: true
      t.bigint :created_by

      t.timestamps
    end
  end
end