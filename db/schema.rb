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

ActiveRecord::Schema.define(version: 2019_08_30_165313) do

  create_table "body_parts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_body_parts_on_name", unique: true
  end

  create_table "muscle_posts", force: :cascade do |t|
    t.text "body", null: false
    t.string "title", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_muscle_posts_on_user_id"
  end

  create_table "tag_maps", force: :cascade do |t|
    t.integer "body_part_id"
    t.integer "muscle_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["body_part_id"], name: "index_tag_maps_on_body_part_id"
    t.index ["muscle_post_id"], name: "index_tag_maps_on_muscle_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "icon", null: false
    t.string "identity", null: false
    t.text "introduction", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.boolean "unsubscribed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "email", null: false
    t.index ["identity"], name: "index_users_on_identity", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
