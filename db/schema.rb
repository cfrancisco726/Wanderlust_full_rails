# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170709225820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flights", force: :cascade do |t|
    t.string "departing_airline"
    t.string "arriving_airline"
    t.integer "flight_price"
    t.boolean "booked?"
    t.text "flight_number"
    t.bigint "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_flights_on_trip_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.boolean "booked?"
    t.bigint "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_hotels_on_trip_id"
  end

  create_table "response_flight_data", force: :cascade do |t|
    t.string "saleTotal"
    t.string "carrier"
    t.string "arrival_time_when_leaving_home"
    t.string "departure_time_when_leaving_home"
    t.string "arrival_time_when_coming_home"
    t.string "departure_time_when_coming_home"
    t.string "origin"
    t.string "destination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.integer "budget"
    t.string "origin"
    t.date "departure_date"
    t.date "arrival_date"
    t.integer "passengers"
    t.boolean "booked?"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
