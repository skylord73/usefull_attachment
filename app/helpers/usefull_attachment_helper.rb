#Add here view and controller helpers
module UsefullAttachmentHelper
  def new_attachment_tag(object)
    #ToDo check the relation type and assure is UsefullAttachment::Link
    if object.respond_to?(:links)
      form_for object.links.build, :html => {:multipart => true} do |f|
        f.file_field :file
        f.text_field :description
        f.submit
      end
    end
    
  end
  
end

