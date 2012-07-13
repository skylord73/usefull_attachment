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
   fn = attachment.instance.file_file_name.split(".")
   fn.pop
   fn.join(".")
 end
 
 Paperclip.interpolates :extension do |attachment, style|
   attachment.instance.file_file_name.split(".").pop
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
end

