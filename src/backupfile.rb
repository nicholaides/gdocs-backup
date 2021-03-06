require 'yaml'

module GDocsBackup
  class BackupFile
    def initialize(file_name)
      @file_name = file_name
      
      @id = File.basename(file_name).split(' - ').first 
      
      @yaml_file = File.join(File.dirname(@file_name), "#{@id}.yml")
      @pdf_file = File.join(File.dirname(@file_name), "#{@id}.pdf")
      @attributes = YAML.load(File.new(@yaml_file))
    end
    
    def preview?
      File.exist? @pdf_file
    end
    
    def preview_path
      @pdf_file
    end
    
    def size
      File.size?(@file_name) || 0
    end
    
    def to_s
      title
    end
    
    #proxy the attributes hash
    def method_missing(method, *args)
      if method.to_s =~ /=$/
        @attributes[ method.to_s.gsub(/=$/, '').to_sym ] = args
      else
        @attributes[method]
      end
    end
    
    #have to override these
    def id
      @attributes[:id]
    end
    
    def type
      @attributes[:type]
    end
  end
end