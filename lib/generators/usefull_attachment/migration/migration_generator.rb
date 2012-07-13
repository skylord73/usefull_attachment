require 'rails/generators'
require 'rails/generators/migration'

module UsefullAttachment
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    desc "Migration generator for UsefullAttachment gem"
    source_root File.expand_path("../templates", __FILE__)
    
    def copy_migration
      migration_template "create_migration_template.rb", "db/migrate/create_links.rb"
    end
    
    #def copy_public
    #  directory "public"
    #end
    
  end      
end