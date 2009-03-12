require 'gdocs'
require 'yaml'
require 'backupfile'

class Backup
  attr_accessor :timestamp
  
  def self.list
    Dir[ File.join(GDocs::BACKUPS_DIR,'*') ].map{|dir| Backup.new(dir) }.sort_by(&:timestamp).reverse
  end
  
  def initialize(dir)
    @dir = dir
  end
  
  def timestamp
    @timestamp ||= Time.at(File.basename(@dir).to_i)
  end
  
  def to_s
    @to_s ||= did_when(timestamp)
  end
  
  def files
    @files ||= Dir[ File.join(@dir, '*') ].grep(/\S - /).map{|file_name| GDocsBackup::BackupFile.new(file_name) }
  end
  
  private
    def did_when(time)
      #thanks to http://snippets.dzone.com/posts/show/5715
      val = Time.now - time
      #puts val
      if val < 10
        'just a moment ago'
      elsif val < 60
        'less than a minute ago'
      elsif val < 60 * 50
        mins = (val / 60).to_i
        "#{mins} minute#{'s' if mins > 1} ago"
      elsif val < 60  * 60  * 1.4
        'about 1 hour ago'
      elsif val < 60  * 60 * (24 / 1.02)
        "about #{(val / 60 / 60 * 1.02).to_i} hours ago"
      else
        time.strftime("%H:%M %p %B %d, %Y")
      end
    end
    
end