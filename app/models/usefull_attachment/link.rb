#Gestisce gli allegati dei documenti
#
#Salava i documenti in /mnt/Webgatec/<namespace>/<class>/id/file_name
#
#Nel caso sia necessario avere una relazione diversa ovvero 1 attachment -> molti recordo (vedi PhoneQueue) derivare la casse
#*  PhoneQueueAttach
#
module UsefullAttachment
  class Link < ActiveRecord::Base
    
    acts_as_monitor
    #Rename file after save if attachmentable provide a rename_attachment method
    before_save do
      #UserSession.log("Admin::Attachment#after_save respond=#{self.attachmentable.inspect}")
      rename(self.attachmentable.send(:attachment_name, self.file_file_name, self.description)) if self.attachmentable.respond_to?(:attachment_name, true)
      #UserSession.log("Admin::Attachment#after_save name=#{self.file_file_name}")
    end
    
    has_attached_file :file,
                      #:path => "/mnt/WebGatec/:type/:type_id/:filename",
                      :path => :get_path,
                      :url => :get_url,
                      #Nota: le options di :styles devono essere String altrimenti si pianta tutto
                      :styles => {:import => "true"},
                      :processors => [:file_processor]
                      
    validates_attachment_presence :file
    
    belongs_to :attachmentable , :polymorphic => true
    #has_many :phonequeues, :class_name => "Utility::PhoneQueue", :dependent => :destroy
    #has_many :attachments, :class_name => "Admin::Attachment", :as => :attachmentable
    
    #Importa il file nel modello dichiarato vedi Spreadsheet::Workbook#to_record
    #*	:model => passa la parent class della tabella per� ha sempre la precedenza il nome del foglio di lavoro se � un modello valido
    #
    #Nel caso il modello (attachmentable_type) sia anche una relazione procede ad inserire i record direttamente. (Vedi PhoneQueueAttach)
    #==Note
    #Passa a to_xls solo i mime-type compatibili
    def to_record(*args)
      if !file.blank? && self.file_content_type == "application/vnd.ms-excel"
        options = args.extract_options!
        options[:model] ||= self.attachmentable_type unless self.attachmentable_type == self.class.name
        out = self.file.to_record(*(args << options)) 
        #Verifico se il modello � una collection, in caso affermativo lo inserisco automaticamente
        association = find_association(options[:model])
        return self.send(association.to_s + "=", out[options[:model]]) if association
        return out
      else
        {}
      end
    end
    
    def rename(new)
      unless self.file_file_name.nil?
        path = self.file.path.split("/")
        path.pop
        File.rename(self.file.path, path.push(new).join("/")) if File.exist?(self.file.path)
        self.file_file_name = new
      end
    end
    
      
    private
    
    def get_path
      "/mnt/WebGatec/:type/:type_id/:base_name.:extension"
    end
    
    def get_url
      "WebGatec/:type/:type_id/:base_name.:extension"
    end
    
    
    def error_missing?
      !File.exists?(self.file.path)
    end
    
    
    #Gli viene passato un modello e restituisce il nome dell'association relativa se esiste
    def find_association(model)
      association = nil
      self.class.reflections.each {|k,v| association = k if  v.class_name == model}
      association
    end
    
  end
end
