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

ActiveRecord::Schema.define(version: 20210729073328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rewards", force: :cascade do |t|
    t.string   "reward_type"
    t.datetime "expire_at"
    t.boolean  "is_birthday", default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_rewards_on_user_id", using: :btree
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "amount"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_transactions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.date     "birthday"
    t.string   "tier",             default: "standard"
    t.string   "country"
    t.integer  "month_points",     default: 0
    t.integer  "year_points",      default: 0
    t.integer  "last_year_points", default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

end
