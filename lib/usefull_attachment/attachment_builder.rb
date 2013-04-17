module UsefullAttachment
  class AttachmentBuilder < ActionView::Helpers::FormBuilder
    def new_attachment(description = true)
      #ToDo check the relation type and assure is UsefullAttachment::Link
      if @object.respond_to?(:attachments)
        fields_for @object.attachments, :html => {:multipart => true}, :url => usefull_attachment_links_path do |f|
          @template.concat(f.hidden_field :attachmentable_type)
          @template.concat(f.hidden_field :attachmentable_id)
          @template.concat(f.file_field :link)
          @template.concat(f.text_field :description) if description
        end
      end
    end
  end
end
