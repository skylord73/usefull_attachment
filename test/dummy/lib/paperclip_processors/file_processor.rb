module Paperclip
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
        status = `bin/permission.rb`
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