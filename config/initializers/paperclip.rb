#require 'lib/paperclip_processors/excel_processor.rb'

#Paperclip Initializer

#Percorso di Convert
Paperclip.options[:command_path] = "/usr/bin/convert"
Paperclip.options[:whiny] = true

#Definisco dei simboli da utilizzare nel percorso del file
Paperclip.interpolates :type do |attachment, style|
  #attachment.instance.attachmentable_type.blank? ? "default" : attachment.instance.attachmentable_type.underscore
  attachment.instance.attachmentable_type.blank? ? attachment.instance.class.name.underscore : attachment.instance.attachmentable_type.underscore
end

Paperclip.interpolates :type_id do |attachment, style|
   attachment.instance.attachmentable_id.blank? ? attachment.instance.id : attachment.instance.attachmentable_id
 end
 
 Paperclip.interpolates :base_name do |attachment, style|
   fn = attachment.instance.link_file_name.split(".")
   fn.pop
   fn.join(".")
 end
 
 Paperclip.interpolates :extension do |attachment, style|
   attachment.instance.link_file_name.split(".").pop
 end

# Paperclip.configure do |c|
	# c.register_processor :excel, Paperclip::ExcelProcessor
# end

module Paperclip
	class Attachment
    #Se uploaded_file è valorizzato (attachemtn non salvato) usa quello,
    #altrimenti carica il file dal disco
		def to_record(*args)
      self.uploaded_file.blank? ? File.open(self.path).to_record(*args) : self.uploaded_file.to_record(*args)
		end
	end
  
  class FileProcessor < Processor
    
    def initialize file, options = {}, attachment = nil
      @file           = file
      @options        = options
      @instance       = attachment.instance
      @styles					= attachment.options[:styles]
      @whiny          = options[:whiny].nil? ? true : options[:whiny]
      #Rails::logger.info("Paperclip::ExcelProcessor#initialize  options=#{options.inspect}, attachment=#{attachment.inspect}")
      #Rails::logger.info("Paperclip::ExcelProcessor#initialize  STYLES=#{@styles.inspect}, INSTANCE=#{@instance.inspect}")
      #UserSession.log("Paperclip#make @attachment=#{attachment.inspect}")
    end

    def make
      begin
      	#UserSession.log("Paperclip#make @options=#{@options.inspect}")
        #UserSession.log("Paperclip#make @file=#{@file.inspect}")
        #UserSession.log("Paperclip#make @instance=#{@instance.inspect}")
        file = File.join(UsefullAttachment::Engine.root, "bin/permission.rb")
        status = `#{file}`
        #Rails::logger.info("Paperclip::ExcelProcessor#make  user=#{`whoami`.strip}")
        #UserSession.log("Paperclip#make status=#{status.inspect}")
        # # new record, set contents attribute by reading the attachment file
        # if(@instance.new_record?)
          # @file.rewind # move pointer back to start of file in case handled by other processors
          # file_content = File.read(@file.path)
          # @instance.send("#{@options[:contents]}=", file_content)
        # else                                                     
          # # existing record, set contents by reading contents attribute
          # file_content = @instance.send(@options[:contents])
          # # create new file with contents from model
          # tmp = Tempfile.new([@basename, @current_format].compact.join("."))
          # tmp << file_content
          # tmp.flush 
          # @file = tmp
        #end         
                 
        @file
      rescue StandardError => e
        raise PaperclipError, "There was an error processing the file contents for #{@basename} - #{e}" if @whiny
      end
    end
  end
  
end

