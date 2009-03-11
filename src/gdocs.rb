include Java
Dir["lib/java/*.jar"].each{|jar| require jar }

require 'net/http'
require 'uri'
require 'facets/core/facets'

require 'thread'

class GDocs
  DocumentListFeed = com.google.gdata.data.docs.DocumentListFeed
  DocsService = com.google.gdata.client.docs.DocsService 
  def initialize(login, pass)
    @service = DocsService.new("Docs service")
    @service.set_user_credentials login, pass
    @list_url = java.net.URL.new("http://docs.google.com/feeds/documents/private/full")
    @auth_token = @service.getAuthTokenFactory.getAuthToken.getAuthorizationHeader(@list_url, "GET")
  end
  
  def test
    url = URI.parse "http://docs.google.com/feeds/download/documents/Export?docID=df3c8tkp_16cw3wv4&exportFormat=doc"
    res = Net::HTTP.start(url.host) {|http|
      http.get("/feeds/download/documents/Export?docID=df3c8tkp_16cw3wv4&exportFormat=doc", {'Authorization' => @auth_token, 'Accept' => '*/*' })
    }
    p url.path
    p res
    puts res.body
  end
  
  def backup
    feed = @service.getFeed(@list_url, DocumentListFeed.java_class, nil)

    files = feed.entries.map do |entry|
      {}.tap do |h|
        h[:type], h[:id] = entry.resource_id.split(':')
        h[:title]        = entry.title.text
        h[:last_views]   = Time.at(entry.last_viewed.value) if entry.last_viewed
        h[:can_edit?]    = entry.can_edit
        h[:categories]   = entry.categories.map{|c| c.label }.join(', ')
        h[:authors]      = entry.authors.map{|a| "#{a.name} <#{a.email}>" }.join(', ')
      end
    end
    
    files.reject!{|file| file[:type] != 'document' }
  
    gdocs_dir  = File.join(ENV["HOME"], 'gdocs-backups')
    backup_dir = File.join(gdocs_dir, Time.now.to_i.to_s)
    Dir.mkdir(gdocs_dir)  unless File.exist? gdocs_dir
    Dir.mkdir(backup_dir) unless File.exist? backup_dir
    
    @downloading_items = [true]*files.size
    
    puts @auth_token
    
    files.each_with_index do |file, index|
      case file[:type]
        when 'document'
          file[:download_path]      = "/feeds/download/documents/Export?docID=#{file[:id]}&exportFormat=doc"
          file[:download_host]      = 'docs.google.com'
          file[:download_extension] = 'doc'
        when 'presentation'
          file[:download_path]      = "/feeds/download/presentations/Export?docID=#{file[:id]}&exportFormat=ppt"
          file[:download_host]      = 'docs.google.com'
          file[:download_extension] = 'ppt'
        when 'spreadsheet'
          file[:download_path]      = "/feeds/download/spreadsheets/Export?key=#{file[:id]}&fmcmd=4"
          file[:download_host]      = 'spreadsheets.google.com'
          file[:download_extension] = 'xls'
      end
      
      semaphore = Mutex.new
      
      Thread.start(index, files, backup_dir) do |index, files, backup_dir|
        puts file[:download_path]
        file = files[index]
        res = Net::HTTP.start(file[:download_host]) {|http|
          http.get(file[:download_path], {'Authorization' => @auth_token})
        }
        puts res
        file = files[index]
        File.open( File.join(backup_dir, "#{file[:id]} - #{file[:title]}.#{file[:download_extension]}"), 'w' ) do |f|
          f.print res.body
        end
        
        semaphore.synchronize do
          @downloading_items[index] = false
          STDERR.puts "completed #{ @downloading_items.reject{|i| i }.size }/#{@downloading_items.size}"
          STDERR.puts "waiting for: "
          @downloading_items.each_with_index{|item, index|
            p files[index][:title] if item
          }
          puts "All complete!" if @downloading_items.none?
        end
      end
    end
  end
end