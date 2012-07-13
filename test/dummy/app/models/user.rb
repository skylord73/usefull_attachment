class User < ActiveRecord::Base
  has_many :links, :class_name => "UsefullAttachment::Link", :as => :attachmentable
end
