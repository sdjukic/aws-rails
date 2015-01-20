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

ActiveRecord::Schema.define(version: 20150119030626) do

  create_table "user_resources", force: true do |t|
    t.string   "resource_url"
    t.integer  "resource_size"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_name"
  end

  add_index "user_resources", ["user_id", "created_at"], name: "index_user_resources_on_user_id_and_created_at"
  add_index "user_resources", ["user_id"], name: "index_user_resources_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
