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

ActiveRecord::Schema.define(version: 20140926015600) do

  create_table "images", force: true do |t|
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "images", ["note_id"], name: "index_images_on_note_id"

  create_table "notes", force: true do |t|
    t.integer  "position",   default: 0
    t.string   "kind",       default: "Note"
    t.string   "title"
    t.text     "content"
    t.string   "color"
    t.boolean  "archived",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["title", "content"], name: "index_notes_on_title_and_content"
  add_index "notes", ["title"], name: "index_notes_on_title"

  create_table "share_tokens", force: true do |t|
    t.integer  "note_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "share_tokens", ["note_id"], name: "index_share_tokens_on_note_id"

  create_table "tasks", force: true do |t|
    t.integer  "note_id"
    t.string   "content"
    t.boolean  "completed",  default: false
    t.integer  "position",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["note_id"], name: "index_tasks_on_note_id"

  create_table "user_notes", force: true do |t|
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_notes", ["note_id"], name: "index_user_notes_on_note_id"
  add_index "user_notes", ["user_id"], name: "index_user_notes_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
