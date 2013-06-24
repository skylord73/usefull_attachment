#Localize messages in it.CustomError.MyError
module UsefullAttachment

  class CustomError < StandardError
    def initialize(*args)
        @options = args.extract_options!
        super
    end
      
    def message
      @options.merge!({:default => "Error : #{@options.inspect}"})
      I18n.t("#{self.class.name.gsub(/::/,'.')}", @options )
    end
  end 

  module Links
    class FileDuplicate < ::CustomError ; end
    #class MyError < CustomError; end
  end

end