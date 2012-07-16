class User < ActiveRecord::Base
  has_many :links, :class_name => "UsefullAttachment::Link", :as => :attachmentable
  has_one :avatar, :class_name => "UsefullAttachment::Avatar", :as => :attachmentable
end
