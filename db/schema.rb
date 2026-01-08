# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_08_045000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "event_id", null: false
    t.string "name"
    t.string "phone_number"
    t.integer "status"
    t.integer "tickets"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["event_id"], name: "index_bookings_on_event_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "available_tickets"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by"
    t.text "description"
    t.datetime "end_time"
    t.string "image"
    t.string "location"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "start_time"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_events_on_category_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "booking_id", null: false
    t.datetime "created_at", null: false
    t.string "payment_method"
    t.integer "status"
    t.string "transaction_ref"
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone_number"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "events"
  add_foreign_key "bookings", "users"
  add_foreign_key "events", "categories"
  add_foreign_key "payments", "bookings"
end
