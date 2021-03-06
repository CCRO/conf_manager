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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120203105404) do

  create_table "active_calls", :force => true do |t|
    t.string   "sid"
    t.string   "to"
    t.string   "from"
    t.string   "direction"
    t.string   "caller_name"
    t.boolean  "muted"
    t.boolean  "ended"
    t.integer  "active_conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_calls", ["active_conference_id"], :name => "index_active_calls_on_active_conference_id"
  add_index "active_calls", ["sid"], :name => "index_active_calls_on_sid", :unique => true

  create_table "active_conferences", :force => true do |t|
    t.string   "sid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friendly_name"
  end

  add_index "active_conferences", ["sid"], :name => "index_active_conferences_on_sid", :unique => true

  create_table "conferences", :force => true do |t|
    t.string   "confname"
    t.string   "pin"
    t.string   "sid"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "user"
    t.string   "phone"
    t.string   "pin"
    t.string   "muted"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
