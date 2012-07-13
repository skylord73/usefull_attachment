class User < ActiveRecord::Base
  has_many :links, :as => :attachmentable
end
