# Mike Nicholaides
# mike.nicholaides@gmail.com
# CS338: GUI, Assignment 2
$LOAD_PATH <<  File.dirname(__FILE__)
require 'set_load_path'

require 'profligacy/swing'
require 'profligacy/lel'
require 'facets/core/facets'

require 'gui_shortcuts'
require 'list_model'

require 'login_window'
require 'main_window'
require 'gdocs'

class Driver
  def initialize
    @main_window = MainWindow.new
    prompt_for_login_info
  end
  
  def login_info=(user_pass_arr)
    @gdocs = GDocs.new(*user_pass_arr)
  rescue
    prompt_for_login_info("Could not log you in. Please try again")
  end
  
  def quit_unless_logged_in
    exit unless @gdocs
  end
  
  private
    def prompt_for_login_info(err_message = nil)
      LoginWindow.new(self, @main_window.frame, err_message)
    end
end

SwingUtilities.invoke_later proc{ Driver.new }.to_runnable