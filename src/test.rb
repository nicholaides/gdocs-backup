require 'src/set_load_path'
include Java
Dir["lib/java/*.jar"].each{|jar| require jar }

class GDocs
  def initialize
    service = com.google.gdata.client.docs.DocsService.new("Docs service")
    service.set_user_credentials "mike.nicholaides@gmail.com", 'kwme34xw'

    list_url = java.net.URL.new("http://docs.google.com/feeds/documents/private/full")
    DocumentListFeed = com.google.gdata.data.docs.DocumentListFeed

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