class AddTypology < ActiveRecord::Migration
  def self.up
    add_column :usefull_attachment_links, :typology, :string
  end

  def self.down
  end
end
