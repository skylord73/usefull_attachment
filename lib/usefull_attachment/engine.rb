module UsefullAttachment
  class Engine < Rails::Engine
    
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    initializer 'usefull_attachment.helper' do |app|
      ActiveSupport.on_load(:action_controller) do
        include UsefullAttachmentHelper
      end
      ActiveSupport.on_load(:action_view) do
        include UsefullAttachmentHelper
      end
     
    end
  end
  
end

#Add ere require to specific file or gem used

require "paperclip"
module Paperclip
  module Storage
    module Filesystem

      # Patch alla cancellazione di Paperclip che tenta di cancellare tutto quello che può finchè non fallisce la cancellazione
      # a livello di sistema operativo, tale modalità di cancellazione però crea problemi con le share su ALfresco montate
      # tramite CIFS.
      def flush_deletes #:nodoc:
        @queued_for_delete.each do |path|
          begin
            log("deleting #{path}")
            FileUtils.rm(path) if File.exist?(path)
          rescue Errno::ENOENT => e
            # ignore file-not-found, let everything else pass
          end
          begin
		   # Per controllare se la cartella è vuota verifico il numero di elementi al suo interno e gli tolgo i 2 file "di
		   # servizio" di Alfresco, ossia "__Forza-Versione.exe" e "__Mostra-Dettagli.exe" presenti in ogni cartella esposta
		   # da Alfresco tramite CIFS. Gli tolgo inoltre le/i cartelle/riferimenti del sistema operativo "." e "..". Se il
		   # numero che così ottengo è minore di 0 significa che la cartella era vuota: il numero potrebbe essere negativo
		   # perchè WebGATeC non è sempre montato su Alfresco, per cui a volte mi trovo a togliere anche 2 elementi che in
            # realtà non c'erano.
		   tmp_dir = File.dirname(path)
		   while( Dir.entries(tmp_dir).size - 2 - 2 <= 0 )
			 FileUtils.rmdir(tmp_dir)
			 tmp_dir = File.dirname(tmp_dir)
		   end
          rescue Errno::EEXIST, Errno::ENOTEMPTY, Errno::ENOENT, Errno::EINVAL, Errno::ENOTDIR, Errno::EACCES
            # Stop trying to remove parent directories
          rescue SystemCallError => e
            log("There was an unexpected error while deleting directories: #{e.class}")
            # Ignore it
          end
        end
        @queued_for_delete = []
      end
	
    end
  end
end