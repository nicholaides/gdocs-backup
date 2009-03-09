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
  
  
    @downloading_items = [true]*files.size
    
    files.each_with_index do |file, index|
      format = case file[:type]
      when 'document'
        "docID=#{file[:id]}&exportFormat=doc"
      when 'presentation'
        "docID=#{file[:id]}&exportFormat=ppt"
      when 'spreadsheet'
        "key=#{file[:id]}&fmcmd=4"
      end
      path = "/feeds/download/#{file[:type]}s/Export?#{format}"
      
      semaphore = Mutex.new
      
      Thread.start(index, files, path) do |index, files, path|
        res = Net::HTTP.start("docs.google.com") {|http|
          http.get(path, {'Authorization' => @auth_token})
        }
        
        semaphore.synchronize do
          @downloading_items[index] = false
          puts "completed #{ @downloading_items.select{|i| i }.size }/#{@downloading_items.size}"
          puts "All complete!" if @downloading_items.none?
        end
      end
    end
  end
  
  def stuff
    list_url = java.net.URL.new("http://docs.google.com/feeds/documents/private/full")
    

    feed = service.getFeed(list_url, DocumentListFeed.java_class, nil)
    entries = feed.entries
    for entry in entries
      puts entry.title.text
      puts Time.at(entry.last_viewed.value) if entry.last_viewed
      puts entry.can_edit
      puts entry.categories.map{|c| c.label }.join(', ')
      puts entry.authors.map{|a| "#{a.name} <#{a.email}>" }.join(', ')
      puts entry.self_link.href
      puts entry.html_link.href
      puts 
      puts
    end
    
    auth_token = service.getAuthTokenFactory.getAuthToken.getAuthorizationHeader(list_url, "GET")


    require 'net/http'
    require 'uri'

    id = entries[1].resource_id.gsub(/^.*\:/, '')

    url = URI.parse('http://docs.google.com')
    file_path = "/feeds/download/documents/Export?docID=#{id}&exportFormat=html" 
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get("/feeds/documents/private/full", {'Authorization' => auth_token})
    }
    puts res.body
  end
end