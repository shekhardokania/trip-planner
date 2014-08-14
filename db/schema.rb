# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140813073842) do

  create_table "stations", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "train_paths", force: true do |t|
    t.integer  "to_station_id"
    t.integer  "from_station_id"
    t.decimal  "duration",        precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "train_stations", force: true do |t|
    t.integer  "station_id"
    t.integer  "train_id"
    t.datetime "arrival_time"
    t.datetime "departure_time"
    t.integer  "station_number"
    t.string   "running_days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trains", force: true do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "start_station_id"
    t.integer  "end_station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
