class User < ActiveRecord::Base
  has_many :attachments, :class_name => "UsefullAttachment::Attachment", :as => :attachmentable
  has_one :avatar, :class_name => "UsefullAttachment::Avatar", :as => :attachmentable
end
