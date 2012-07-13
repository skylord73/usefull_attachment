Rails.application.routes.draw do
   namespace :usefull_attachment do
     resources :links do
  		get "download", :on => :member
  	end
  end
end


