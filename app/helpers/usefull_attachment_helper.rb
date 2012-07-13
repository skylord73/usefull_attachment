#Add here view and controller helpers
module UsefullAttachmentHelper
  def new_attachment_tag(object, description = true)
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
  
end

