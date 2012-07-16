class CreateLinks < ActiveRecord::Migration
  create_table "usefull_attachment_links" do |t|
      t.string   "type"
      t.string   "description"
      t.string   "file_content_type"
      t.datetime "file_updated_at"
      t.integer  "file_file_size"
      t.string   "file_file_name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "attachmentable_id"
      t.string   "attachmentable_type", :limit => 100, :null => false
      t.string   "typology"
    end
end