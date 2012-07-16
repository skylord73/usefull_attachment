class User < ActiveRecord::Base
  has_many :attachments, :class_name => "UsefullAttachment::Attachments", :as => :attachmentable
  has_many :avatars, :class_name => "UsefullAttachment::Avatar", :as => :attachmentable
end
