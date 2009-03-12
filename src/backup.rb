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
    @to_s ||= timestamp.time_ago_human
  end
  
  def files
    @files ||= file_names.map{|file_name| GDocsBackup::BackupFile.new(file_name) }
  end
  
  def size
    @size ||= file_names.map{|file_name| File.size?(file_name) }.compact.sum
  end
  
  private
    def file_names
      @file_names ||= Dir[ File.join(@dir, '*') ].grep(/\S - /)
    end
end