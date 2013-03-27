#Gestisce gli allegati dei documenti
#
#Salva i documenti in /mnt/Webgatec/<namespace>/<class>/id/file_name
#   Per implementare nuove tipologie di attachments occorre ereditare da questa
#   classe e ridefinire all'occorrenza i metodi get_path e get_url (privati)
#   se occorre modificare gli styles e i processors occorre ridefinire anche
#   has_attached_file nella classe figlia
#==Descrizione Campi
#-  type => Nome della sottoclasse di Link che ha generato l'allegato
#-  attachmentable_type => classe a cui è collegato l'allegato
#-  attachmentable_id => id della classa a cui è collegato l'allegato
#
#N.B. Vengono tutti popolati in automatico da Rails
#
module UsefullAttachment
  class Link < ActiveRecord::Base
    
    acts_as_monitor
    
    before_validation :check
    before_save :fill
    
    #ToDo aggiungere il cambio permessi al postprocessore di default, che fa il ridemsionamento immagine
    has_attached_file :link,
                      #:path => "/mnt/WebGatec/:type/:type_id/:filename",
                      :path => :get_path,
                      :url => :get_url,
                      #Nota: le options di :styles devono essere String altrimenti si pianta tutto
                      # quando si eredita da Link occorre specificare nuovi styles e processori ad hoc
                      :styles => {:import => "true"},
                      :processors => [:file_processor]
    
    #validates_attachment_presence :link
    #validates :link, :attachment_presence => true
    validates :link_file_name, :presence => true
    
    belongs_to :attachmentable , :polymorphic => true
       
    # ==CLASS Methods
    class<<self
      # importa allegati attraversando rami di directory
      # ogni path è fatto così: /mnt/WebGatec/namespace/model/id/filename.ext
      # 
      def folders_to_records
        Dir["/mnt/WebGatec/**/*"].each do |file|
          if File.file?(file)
            file_path_name = file.split("/")
            file_name = file_path_name.pop
            id = file_path_name.pop
            modello = file_path_name.pop
            name_space = file_path_name.pop
          end
          
          if is_num?(id) && !id.blank? 
            # try to build new record
            # puts name_space + '::' + modello
            begin
              full_class_name = name_space.camelize + '::' + modello.camelize if !name_space.blank?
              if class_defined?(full_class_name)
                self.find_or_create_by_type_and_attachmentable_id_and_attachmentable_type(:description => 'prova',
                                    :link_file_size => file.size,
                                    :link_content_type => MIME::Types.type_for(file).first.content_type,
                                    :link_file_name => File.basename(file),
                                    :type => get_attachment_type(full_class_name),
                                    :attachmentable_id => id,
                                    :attachmentable_type => full_class_name)
              end
              puts "OK => #{name_space} #{modello} #{id} #{file_name}"
            rescue
              puts "KO => #{name_space} #{modello} #{id} #{file_name}"            
            end
          end
        end
      end
      
      #Start Private Class Methods
      private
      
      def class_defined?(s) 
        begin
          eval s.to_s
          true
        rescue NameError
          false
        end
      end
      
      def is_num?(str)
        begin
          !!Integer(str)
        rescue ArgumentError, TypeError
          false
        end
      end
      
      def get_attachment_type(attach_type)
        case attach_type
          when 'Magazzino::Document'
            return 'Documenti::Attachment'
          when 'Magazzino::Limbo'
            return 'Documenti::Attachment'
          when 'Utility::PhoneQueue'
            return 'Utility::PhoneQueueAttach'
          when 'Interventi::Activity'
            return 'Interventi::Attachment'
          when 'Interventi::Import'
            return 'Interventi::Attachment'
          when 'Consuntivazioni::BillingCheck'
            return 'Admin::Attachment'
        end
      end
    
    end
    
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
    
    def url
      link.url
    end
      
    private
    
    #Rename file after save if attachmentable provide an attachment_name method
    def fill
      to_call_name = "#{self.class.name.underscore.split("/").pop}_name"
      mylog("fill respond_to? = #{attachmentable.respond_to?(to_call_name, true)}")
      rename(self.attachmentable.send(to_call_name, self.link_file_name, self.description)) if self.attachmentable.respond_to?(to_call_name, true)
    end
    
    #ToDo da sistemare perchè non fa testo... è una prova del cazzo!!!!
    def check
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
