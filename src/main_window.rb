require 'backup'
require 'extensions'

class MainWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  include GUIShortcuts
  
  def initialize(driver, backups)
    @driver = driver
    @backups = backups
    puts @backups.inspect
    puts @backups.any?
    puts @backups.size
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
      end
    end
  
    def backup_panel
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add title_panel("Backup Details"), N
        jp.add backup_details, C
      end
    end
  
    def backup_details
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add backup_details_fields, N
        jp.add backup_files, C
      end
    end
  
    def backup_details_fields
      layout = "
        [date_l | date]
        [size_l | size]
      "
      Swing::LEL.new JPanel, layout do |c,i|
        c.date_l = @date_label = l('Date')
        c.date = @date_field = l('...')
        c.size_l = l('Size')
        c.size = @size_field = l('...')
      end.build
    end
  
    def backup_files
      @files = ListModel.new
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add number_of_files_label, N
        jp.add JList.new(@files), C
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
          c.restore = b "Restore"
          c.delete  = b "Delete"
        }, S)
      end
    end
    
    def backups_list
      @backups_list = JList.new(@backups).tap do |list|
        list.addListSelectionListener(proc{|sym, args|
          changeBackupPane
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
        label.name = "file_title"
      end
    end
  
    def file_details
      two_column_panel(:type, :owner, :shared_with, :size, :created_at, :last_modified)
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
    
    def changeBackupPane
      @date_field.text = current_backup.timestamp.strftime Time::FORMAT[:long]
      @size_field.text = current_backup.size.to_human
    end
    
    def current_backup
      @backups[@backups_list.get_selected_index]
    end
end