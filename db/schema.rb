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

ActiveRecord::Schema[8.0].define(version: 2025_12_03_095502) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_favorites_on_property_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.integer "property_id", null: false
    t.string "image_url"
    t.string "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uploaded_by_id", null: false
    t.index ["property_id"], name: "index_images_on_property_id"
    t.index ["uploaded_by_id"], name: "index_images_on_uploaded_by_id"
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "property_id", null: false
    t.text "message"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_preference", default: "email"
    t.text "response_message"
    t.datetime "responded_at"
    t.integer "responded_by_id"
    t.index ["property_id"], name: "index_inquiries_on_property_id"
    t.index ["responded_by_id"], name: "index_inquiries_on_responded_by_id"
    t.index ["user_id", "property_id"], name: "index_inquiries_on_user_id_and_property_id", unique: true
    t.index ["user_id"], name: "index_inquiries_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.string "location"
    t.string "property_type"
    t.string "status"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.float "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.json "additional_information", default: {"information"=>"unknown"}
    t.integer "floor_number"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "favorites", "properties"
  add_foreign_key "favorites", "users"
  add_foreign_key "images", "properties"
  add_foreign_key "images", "users", column: "uploaded_by_id"
  add_foreign_key "inquiries", "properties"
  add_foreign_key "inquiries", "users"
  add_foreign_key "inquiries", "users", column: "responded_by_id"
  add_foreign_key "properties", "users"
end
