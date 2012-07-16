module UsefullAttachmentHelper

  #Create a button to add new file to attachment system
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
  
  def new_avatar_for(object)
    if object.respond_to?(:avatars)
      form_for object.avatars.build, :html => {:multipart => true}, :url => usefull_attachment_links_path do |f|
        concat(f.hidden_field :attachmentable_type)
        concat(f.hidden_field :attachmentable_id)
        concat(f.file_field :file)
        concat(f.submit)
      end
    end
  end
  
  
  #Create a table to show attachments
  def list_attachments_for(object, full = false)
    if object.respond_to?(:links) && object.links.present?
      Rails::logger.info("list_attachments_for obj.links=#{object.links.inspect}")
      table_for object.links do |t|
        #t.monitor
        t.download :url => Proc.new {|object| Rails::logger.info("list_attachments_for obj=#{object.inspect}"); download_usefull_attachment_link_path(1)} 
        #t.destroy :url => Proc.new {|object| usefull_attachment_link_path(object)}
        t.col :file_file_name
        t.col :description
        t.col :file_file_size if full
        t.col :file_file_updated_at if full
      end
    end
  end
  
  #Draw images marked as :avatar
  def show_avatar_for(object, *args)
    if object.respond_to?(:avatars) && object.avatars.present?
      image_tag(object.avatars.first.file.url, :size => "200x200")
    end
  end
  
  
end

