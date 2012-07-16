class User < ActiveRecord::Base
  has_many :links, :class_name => "UsefullAttachment::Link", :as => :attachmentable
  has_many :avatars, :class_name => "UsefullAttachment::Avatar", :as => :attachmentable
end
