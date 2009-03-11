require 'gdocs'
require 'yaml'

class Backup
  attr_accessor :timestamp
  
  def self.list
    Dir["#{GDocs::BACKUPS_DIR}/*"].map{|dir| Backup.new(dir) }
  end
  
  def initialize(dir)
    @timestamp = Time.at(File.basename(dir).to_i)
  end
  
  def to_s
    did_when(@timestamp)
  end
  
  private
    def did_when(time)
      #thanks to http://snippets.dzone.com/posts/show/5715
      val = Time.now - time
      #puts val
      if val < 10 then
        'just a moment ago'
      elsif val < 40  then
        'less than ' + (val * 1.5).to_i.to_s.slice(0,1) + '0 seconds ago'
      elsif val < 60 then
        'less than a minute ago'
      elsif val < 60 * 1.3  then
        "1 minute ago"
      elsif val < 60 * 50  then
        "#{(val / 60).to_i} minutes ago"
      elsif val < 60  * 60  * 1.4 then
        'about 1 hour ago'
      elsif val < 60  * 60 * (24 / 1.02) then
        "about #{(val / 60 / 60 * 1.02).to_i} hours ago"
      else
        time.strftime("%H:%M %p %B %d, %Y")
      end
    end
    
end