module UsefullAttachment
  class Engine < Rails::Engine
    
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    initializer 'usefull_attachment.helper' do |app|
      ActiveSupport.on_load(:action_controller) do
        include UsefullAttachmentHelper
      end
      ActiveSupport.on_load(:action_view) do
        include UsefullAttachmentHelper
      end
     
    end
  end
  
end

#Add ere require to specific file or gem used