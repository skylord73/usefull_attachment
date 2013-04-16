module UsefullAttachmentHelper

  #Create a button to add new file to attachment system
  def new_attachment_for(object, description = true)
    #ToDo check the relation type and assure is UsefullAttachment::Link
    if object.respond_to?(:attachments)
      form_for object.attachments.new, :html => {:multipart => true}, :url => usefull_attachment_links_path do |f|
        concat(f.hidden_field :attachmentable_type)
        concat(f.hidden_field :attachmentable_id)
        concat(f.file_field :link)
        concat(f.text_field :description) if description
        concat(f.submit)
      end
    end
    
  end
  
  def new_avatar_for(object)
    if object.respond_to?(:avatar)
      if object.avatar.blank?
        form_for object.build_avatar, :html => {:multipart => true}, :url => usefull_attachment_links_path do |f|
          concat(f.hidden_field :attachmentable_type)
          concat(f.hidden_field :attachmentable_id)
          concat(f.file_field :link)
          concat(f.submit 'Avatar')
        end
      else
        link_to 'Delete', usefull_attachment_link_path(object.avatar.id), :method => :delete, :confirm => 'Are you sure'
      end
    end
  end
  
  
  #Create a table to show attachments
  def list_attachments_for(object, full = false)
    if object.respond_to?(:attachments) && object.attachments.present?
      table_for object.attachments.where(:id.ne => nil), :export => {:visible => false} do |t|
        t.monitor
        t.download :url => Proc.new {|object| download_usefull_attachment_link_path(object.id)} 
        t.destroy :url => Proc.new {|object| usefull_attachment_link_path(object.id)}
        t.col :link_file_name
        t.col :description
        t.col :link_file_size if full
        t.col :link_file_updated_at if full
      end
    end
  end
  
  #Draw images marked as :avatar
  def show_avatar_for(object, *args)
    if object.respond_to?(:avatar) && object.avatar.present?
      image_tag(object.avatar.link.url, :size => "200x200")
    end
  end
  
  
end

