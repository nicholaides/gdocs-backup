require 'backup'
require 'extensions'

class MainWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include_package 'javax.swing.border'
  include Profligacy
  include GUIShortcuts
  
  def initialize(driver, backups)
    @driver = driver
    @backups = backups
    @files = ListModel.new
    
    @main_frame = Swing::Build.new(JFrame, :x){}.build("Simple Draw") do |c|
      c.add backup_now_panel, N
      c.add main_panel, C
    end
    @main_frame.default_close_operation = JFrame::EXIT_ON_CLOSE
    
    @backups.contents_changed
  end
  
  def frame
    @main_frame
  end
  
  private
    def backup_now_panel
      panel :backup_now, :last_backup do |c, i|
        c.backup_now  =  b("Backup Now")
        c.last_backup =  last_backup_label #@last_backup_l = l("")
        
        i.backup_now = a{ @driver.backup_now }
      end
    end
  
    def main_panel
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add backups_panel, W
        jp.add backup_panel, C
        jp.add file_panel, E
        jp.border = EmptyBorder.new(10,10,10,10)
      end
    end
  
    def backup_panel
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add title_panel("Backup Details"), N
        jp.add backup_details, C
        jp.border = EmptyBorder.new(10,10,10,10)
      end
    end
  
    def backup_details
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add backup_details_fields, N
        jp.add backup_files, C
      end
    end
  
    def backup_details_fields
      two_column_panel(:date, :total_size)
    end
  
    def backup_files
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add number_of_files_label, N
        jp.add backup_files_list, C
      end
    end
    
    def backup_files_list
      @files_list = JList.new(@files).tap do |list|
        list.addListSelectionListener(proc{|sym, args|
          change_file_pane
        }.to_listener(:list_selection))
      end
    end
  
    def number_of_files_label
      @number_of_files_label = JLabel.new.tap do |label|
        @files.addListDataListener(proc{
          label.text = "#{@files.size} files backed up"
        }.to_listener(:list_data))
      end
    end
    
    def last_backup_label
      @number_of_files_label = JLabel.new.tap do |label|
        @backups.addListDataListener(proc{
          label.text = last_backup_text
        }.to_listener(:list_data))
      end
    end
  
    def backups_panel
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add title_panel("Previous Backups"), N
        jp.add backups_list, C
        jp.add( panel(:restore, :delete) { |c,i|
          c.delete  = b "Delete"
        }, S)
      end
    end
    
    def backups_list
      @backups_list = JList.new(@backups).tap do |list|
        list.addListSelectionListener(proc{|sym, args|
          change_backup_pane
        }.to_listener(:list_selection))
      end
    end
  
    def file_panel
      JPanel.new.tap do |jp|
        jp.layout = BoxLayout.new(jp, BoxLayout::Y_AXIS)
        jp.add file_title
        jp.add file_details
        jp.add file_preview
      end
    end
  
    def file_title
      title_panel("File title") do |label|
        @file_title_field = label
      end
    end
  
    def file_details
      two_column_panel(:type, :author, :size, :last_viewed, :can_edit)
    end
    
    def file_preview
      panel :preview do |c, i|
        c.preview = b "Preview Document"
        i.preview = { :action => proc{ puts "button clicked" } }
      end
    end
    
    def last_backup_text
      if @backups.any?
        "Last backed up " + @backups.first.to_s
      else
        puts "23"
        "Not backed up yet (#{@backups.inspect})"
      end
    end
    
    def change_backup_pane
      @components["date_field"].text = current_backup.timestamp.strftime Time::FORMAT[:long]
      @components["total_size_field"].text = current_backup.size.to_human_file_size
      
      @files.clear 
      @files.concat current_backup.files
    end
    
    def change_file_pane
      @components["type_field"].text = current_file.type
      @components["author_field"].text = current_file.authors
      @components["last_viewed_field"].text = current_file.last_viewed.try(:time_ago_human) || ""
      @components["can_edit_field"].text = current_file.can_edit? ? 'yes' : 'no'
      @components["size_field"].text = current_file.size.to_human_file_size
      @file_title_field.text = current_file.title
    end
    
    def current_file
      @files[@files_list.get_selected_index]
    end
    
    def current_backup
      @backups[@backups_list.get_selected_index]
    end
end