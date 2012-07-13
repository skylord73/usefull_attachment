#Add here view and controller helpers
module UsefullAttachmentHelper
  def new_attachment_for(object, description = true)
    #ToDo check the relation type and assure is UsefullAttachment::Link
    if object.respond_to?(:links)
      form_for object.links.build, :html => {:multipart => true} do |f|
        concat(f.hidden_field :attachmentable_type)
        concat(f.hidden_field :attachmentable_id)
        concat(f.file_field :file)
        concat(f.text_field :description) if description
        concat(f.submit)
      end
    end
    
  end
  
  def list_attachments_for(object, full = false)
    if object.respond_to?(:links) && object.links.present?
      table_for object.links do |t|
        t.download :url => Proc.new {|object| download_usefull_attachment_link_path(object)}
        t.destroy :url => Proc.new {|object| usefull_attachment_link_path(object)}
        t.col :file_file_name
        t.col :description
        t.col :file_file_size if full
        t.col :file_file_updated_at if full
      end
    end
  end
  
  
end

