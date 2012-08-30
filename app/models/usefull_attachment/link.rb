#Gestisce gli allegati dei documenti
#
#Salava i documenti in /mnt/Webgatec/<namespace>/<class>/id/file_name
#
#==Descrizione Campi
#-  type => Nome della sottoclasse di Lionk che ha generato l'allegato
#-  attachmentable_type => classe a cui è collegato l'allegato
#-  attachmentable_id => id della classa a cui è collegato l'allegato
#
#N.B. Vengono tutti popolati in automatico da Rails
#
module UsefullAttachment
  class Link < ActiveRecord::Base
    
    acts_as_monitor
    
    before_validation :validate
    before_save :fill
    
    has_attached_file :link,
                      #:path => "/mnt/WebGatec/:type/:type_id/:filename",
                      :path => :get_path,
                      :url => :get_url,
                      #Nota: le options di :styles devono essere String altrimenti si pianta tutto
                      :styles => {:medium => "300x300", :large => "600x600"},
                      :processors => [:file_processor]
                      
    
    #validates_attachment_presence :link
    #validates :link, :attachment_presence => true
    
    belongs_to :attachmentable , :polymorphic => true
    
    
    #Importa il file nel modello dichiarato vedi Spreadsheet::Workbook#to_record
    #*	:model => passa la parent class della tabella però ha sempre la precedenza il nome del foglio di lavoro se è un modello valido
    #
    #Nel caso il modello (attachmentable_type) sia anche una relazione procede ad inserire i record direttamente. (Vedi PhoneQueueAttach)
    #==Note
    #Passa a to_xls solo i mime-type compatibili
    def to_record(*args)
      if !link.blank? && self.link_content_type == "application/vnd.ms-excel"
        options = args.extract_options!
        options[:model] ||= self.attachmentable_type unless self.attachmentable_type == self.class.name
        out = self.link.to_record(*(args << options)) 
        #Verifico se il modello è una collection, in caso affermativo lo inserisco automaticamente
        association = find_association(options[:model])
        return self.send(association.to_s + "=", out[options[:model]]) if association
        return out
      else
        {}
      end
    end
    
    def rename(new)
      puts("rename new=#{new}")
      unless self.link_file_name.nil?
        path = self.link.path.split("/")
        path.pop
        File.rename(self.link.path, path.push(new).join("/")) if File.exist?(self.link.path)
        self.link_file_name = new
      end
    end
    
      
    private
    
    #Rename file after save if attachmentable provide an attachment_name method
    def fill
      to_call_name = "#{self.class.name.underscore.split("/").pop}_name"
      puts("fill respond_to? = #{attachmentable.respond_to?(to_call_name, true)}")
      puts("Method name= #{to_call_name}")
      rename(self.attachmentable.send(to_call_name, self.link_file_name, self.description)) if self.attachmentable.respond_to?(to_call_name, true)
    end
    
    #ToDo da sistemare perchè non fa testo... è una prova del cazzo!!!!
    def validate
      respond_to?(:link_file_name)
    end
    
    
    def get_path
      "/mnt/WebGatec/:type/:type_id/:base_name.:extension"
    end
    
    def get_url
      get_path
    end
    
    
    def error_missing?
      !File.exists?(self.link.path)
    end
    
    
    #Gli viene passato un modello e restituisce il nome dell'association relativa se esiste
    def find_association(model)
      association = nil
      self.class.reflections.each {|k,v| association = k if  v.class_name == model}
      association
    end
    
  end
end
