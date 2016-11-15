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

ActiveRecord::Schema.define(version: 20161114192529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_choices", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "question_choice_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "question_id"
    t.text     "string_value"
    t.integer  "checkbox_value"
    t.integer  "answer_id"
    t.decimal  "decimal_value"
    t.integer  "integer_value"
    t.integer  "document_id"
    t.integer  "user_id"
    t.integer  "question_choice_id"
  end

  create_table "documents", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "survey_id"
    t.string   "author"
    t.string   "title"
  end

  create_table "flags", force: :cascade do |t|
    t.integer  "flaggable_id"
    t.string   "flaggable_type"
    t.text     "reasoning"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "question_choices", force: :cascade do |t|
    t.integer  "question_id"
    t.string   "label"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "short_label"
  end

  create_table "questions", force: :cascade do |t|
    t.text     "content"
    t.integer  "survey_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "question_type"
    t.index ["survey_id"], name: "index_questions_on_survey_id", using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "instructions"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "questions", "surveys"
end
