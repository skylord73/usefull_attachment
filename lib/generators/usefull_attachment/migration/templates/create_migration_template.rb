class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :usefull_attachment_links do |t|
      
      t.string      :description
      t.string      :typology
      
      t.integer     :created_by
      t.integer     :updated_by
      t.timestamps
      t.string      :type
      t.integer     :attachmentable_id
      t.string      :attachmentable_type, :limit => 100, :null => false
      
    end
  end
  
  def self.down
    drop_table :usefull_table:attachment_links
  end
  
end