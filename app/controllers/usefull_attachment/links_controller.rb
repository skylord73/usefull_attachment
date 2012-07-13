module UsefullAttachment
  class LinksController < ApplicationController
    def index
      @search = Link.search(params[:search])
      @attachments = @search.paginate(:page => params[:page])
    end
    
    def new
      @attachment = Link.new
      #UserSession.log("Admin::AttachmentController#new params=#{params[:admin_attachment].inspect}, @attachment=#{@attachment.inspect}")
    end
    
    def create
      ##UserSession.log("Admin::AttachmentController#create params=#{params[:admin_attachment].inspect}")
      Link.create(params[:admin_attachment])
      redirect_to :action => "index"
    end

    def download
      @attachment = Link.find(params[:id])
      respond_to do |format|
        format.html do
          raise FileMissing.new(:file => @attachment.file.path) unless File.exist?(@attachment.file.path)
          send_file @attachment.file.path, :type => @attachment.file_content_type
        end
      end
    rescue => e
      flash[:alert] = e.message
      redirect_to :back
    end

    def destroy
      @attachment = Link.find(params[:id])
      @attachment.destroy

      respond_to do |format|
       format.html { redirect_to :back }
       format.xml  { head :ok }
      end
    end

  end



end
