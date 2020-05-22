# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_22_122141) do

  create_table "jobs", force: :cascade do |t|
    t.integer "waypoint_id", null: false
    t.boolean "error"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["waypoint_id"], name: "index_jobs_on_waypoint_id"
  end

  create_table "sidekiq_jobs", force: :cascade do |t|
    t.string "jid"
    t.string "queue"
    t.string "class_name"
    t.text "args"
    t.boolean "retry"
    t.datetime "enqueued_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "status"
    t.string "name"
    t.text "result"
    t.index ["class_name"], name: "index_sidekiq_jobs_on_class_name"
    t.index ["enqueued_at"], name: "index_sidekiq_jobs_on_enqueued_at"
    t.index ["finished_at"], name: "index_sidekiq_jobs_on_finished_at"
    t.index ["jid"], name: "index_sidekiq_jobs_on_jid"
    t.index ["queue"], name: "index_sidekiq_jobs_on_queue"
    t.index ["retry"], name: "index_sidekiq_jobs_on_retry"
    t.index ["started_at"], name: "index_sidekiq_jobs_on_started_at"
    t.index ["status"], name: "index_sidekiq_jobs_on_status"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_vehicles_on_identifier"
  end

  create_table "waypoints", force: :cascade do |t|
    t.integer "vehicle_id", null: false
    t.datetime "sent_at"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sent_at"], name: "index_waypoints_on_sent_at"
    t.index ["vehicle_id"], name: "index_waypoints_on_vehicle_id"
  end

  add_foreign_key "jobs", "waypoints"
  add_foreign_key "waypoints", "vehicles"
end
