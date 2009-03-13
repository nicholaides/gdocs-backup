# Mike Nicholaides
# mike.nicholaides@gmail.com
# CS338: GUI, Assignment 2
#$LOAD_PATH <<  File.dirname(__FILE__)
require 'set_load_path'

require 'profligacy/swing'
require 'profligacy/lel'
require 'facets/facets'

require 'gui_shortcuts'
require 'list_model'

require 'login_window'
require 'main_window'
require 'progress_window'
require 'gdocs'
require 'backup'

include Java

class Driver
  attr :backups
  
  def initialize
    @backups = ListModel.new
    load_backups
    
    @main_window = MainWindow.new(self, @backups)
    
    if ARGV.empty?
      prompt_for_login_info
    else
      self.login_info = ARGV
    end
  end
  
  def login_info=(user_pass_arr)
    @gdocs = GDocs.new(*user_pass_arr)
  rescue NativeException
    puts $!
    prompt_for_login_info("Could not log you in. Please try again")
  end
  
  def quit_unless_logged_in
    java.lang.System.exit(0) if @gdocs.nil?
  end
  
  def backup_now
    progress_window = ProgressWindow.new(self, @main_window.frame)
    @gdocs.backup(progress_window)
  end
  
  def backingup_complete!
    load_backups
    @main_window.backup_complete
  end
  
  def delete_backups(backups)
    backups.each &:delete!
    load_backups
  end
  
  private
    def load_backups
      @backups.clear
      @backups.concat Backup.list
      @main_window.update_backups if @main_window
    end
  
    def prompt_for_login_info(err_message = nil)
      LoginWindow.new(self, @main_window.frame, err_message)
    end
end

SwingUtilities.invoke_later proc{ Driver.new }.to_runnable