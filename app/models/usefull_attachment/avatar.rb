module UsefullAttachment
  class Avatar < Link
    
    private
    
    def get_path
      "/mnt/Webgatec/avatars/:type/:type_id/:base_name.:extension"
    end
    
    def get_url
      "/images/avatars/:type/:type_id/:base_name.:extension"
    end
    
  end
  
end