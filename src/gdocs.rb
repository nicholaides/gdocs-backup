include Java
Dir["lib/java/*.jar"].each{|jar| require jar }

require 'net/http'
require 'uri'
require 'facets/core/facets'

require 'easy_thread'
require 'yaml'

class GDocs
  DocumentListFeed = com.google.gdata.data.docs.DocumentListFeed
  DocsService = com.google.gdata.client.docs.DocsService 
  SpreadsheetService = com.google.gdata.client.spreadsheet.SpreadsheetService
  
  BACKUPS_DIR = File.join(ENV["HOME"], 'gdocs-backups')
  
  def initialize(login, pass)
    @docs_service = DocsService.new("Docs service")
    @docs_service.set_user_credentials login, pass
    @docs_list_url = java.net.URL.new("http://docs.google.com/feeds/documents/private/full")
    @docs_auth_token = @docs_service.getAuthTokenFactory.getAuthToken.getAuthorizationHeader(@docs_list_url, "GET")
    puts @docs_auth_token
    
    @spreadsheet_service = SpreadsheetService.new("Spreadsheet service")
    @spreadsheet_service.set_user_credentials login, pass
    @spreadsheet_list_url = java.net.URL.new("http://spreadsheets.google.com/feeds/spreadsheets/private/full")
    @spreadsheet_auth_token = @spreadsheet_service.getAuthTokenFactory.getAuthToken.getAuthorizationHeader(@spreadsheet_list_url, "GET")
    puts @spreadsheet_auth_token
  end
  
  def backup(observer=nil)
    semaphore = Mutex.new
    
    thread do
      semaphore.synchronize do
        observer.update_status "Getting list of files" if observer
        observer.update_progress(0, 0) if observer
      end
      
      feed = @docs_service.getFeed(@docs_list_url, DocumentListFeed.java_class, nil)

      files = feed.entries.map do |entry|
        {}.tap do |h|
          h[:type], h[:id] = entry.resource_id.split(':')
          h[:title]        = entry.title.text
          h[:last_viewed]  = Time.at(entry.last_viewed.value) if entry.last_viewed
          h[:can_edit?]    = entry.can_edit
          h[:categories]   = entry.categories.map{|c| c.label }.join(', ')
          h[:authors]      = entry.authors.map{|a| "#{a.name} <#{a.email}>" }.join(', ')
        end
      end
      
      semaphore.synchronize do
        observer.update_status "Downloading documents" if observer
        observer.update_progress(0, files.size) if observer
      end
  
      backup_dir = File.join(BACKUPS_DIR, Time.now.to_i.to_s)
      Dir.mkdir(BACKUPS_DIR)  unless File.exist? BACKUPS_DIR
      Dir.mkdir(backup_dir) unless File.exist? backup_dir
    
      @downloading_items = [true]*files.size
    
      files.each_with_index do |file, index|
        case file[:type]
          when 'document'
            file[:download_path]      = "/feeds/download/documents/Export?docID=#{file[:id]}&exportFormat=doc"
            file[:download_host]      = 'docs.google.com'
            file[:download_extension] = 'doc'
            file[:auth_token]         = @docs_auth_token
          when 'presentation'
            file[:download_path]      = "/feeds/download/presentations/Export?docID=#{file[:id]}&exportFormat=ppt"
            file[:download_host]      = 'docs.google.com'
            file[:download_extension] = 'ppt'
            file[:auth_token]         = @docs_auth_token
          when 'spreadsheet'
            file[:download_path]      = "/feeds/download/spreadsheets/Export?key=#{file[:id]}&fmcmd=4"
            file[:download_host]      = 'spreadsheets.google.com'
            file[:download_extension] = 'xls'
            file[:auth_token]         = @spreadsheet_auth_token
        end
        
        thread(index, files, file, backup_dir) do |index, files, file, backup_dir|
          puts file[:download_path]
          res = Net::HTTP.start(file[:download_host]) {|http|
            http.get(file[:download_path], {'Authorization' => file[:auth_token]})
          }
          puts res
          file = files[index]
          
          File.open( File.join(backup_dir, "#{file[:id]} - #{file[:title]}.#{file[:download_extension]}"), 'w' ) do |f|
            f.print res.body
          end
          
          File.open( File.join(backup_dir, "#{file[:id]}.yml"), 'w' ) do |f|
            f.print file.except(:auth_token).to_yaml
          end
        
          semaphore.synchronize do
            @downloading_items[index] = false
            complete = @downloading_items.reject{|i| i }.size
            total = @downloading_items.size
            STDERR.puts "completed #{ complete }/#{ total }"
            
            observer.update_progress(complete, total) if observer
            
            if @downloading_items.none?
              observer.complete! if observer
              puts "All complete!"
            end
          end
        end
      end
    end
  end
end