class User < ActiveRecord::Base
  has_many :attachments, :class_name => "UsefullAttachment::Attachment", :as => :attachmentable
  has_many :avatars, :class_name => "UsefullAttachment::Avatar", :as => :attachmentable
end
