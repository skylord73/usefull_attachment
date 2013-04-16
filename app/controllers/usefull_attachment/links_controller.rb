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
      user = current_user ? {:created_by => current_user.id, :updated_by => current_user.id} : {}
      Attachment.create(params[:usefull_attachment_attachment].deep_merge!(user)) if params[:usefull_attachment_attachment].present?
      Avatar.create(params[:usefull_attachment_avatar].deep_merge!(user)) if params[:usefull_attachment_avatar].present?
      Link.create(params[:usefull_attachment_link].deep_merge!(user)) if params[:usefull_attachment_link].present?
      redirect_to :action => "index", :notice => t("created")
    rescue => e
      flash[:alert] = t("not_created", :message => e.message)
      redirect_to :back
    end

    def download
      @attachment = Link.find(params[:id])
      respond_to do |format|
        format.html do
          raise FileMissing.new(:file => @attachment.link.path) unless File.exist?(@attachment.link.path)
          send_file @attachment.link.path, :type => @attachment.link_content_type
        end
      end
    rescue => e
      flash[:alert] = t("not_downloaded", :message => e.message)
      redirect_to :back
    end

    def destroy
      @attachment = Link.find(params[:id])
      @attachment.destroy

      respond_to do |format|
        format.html do
          redirect_to :back, :notice => t("deleted")
        end
        format.xml  { head :ok }
      end
      
    rescue => e
      flash[:alert] = t("not_deleted", :message => e.message)
      redirect_to :back
    end

  end



end
