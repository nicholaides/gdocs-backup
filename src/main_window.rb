require 'backup'
require 'extensions'

class MainWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include_package 'javax.swing.border'
  include Profligacy
  include GUIShortcuts
  
  FILE_ICONS = {
    'document'     => ImageIcon.new('src/icons/file_doc_large.png'),
    'spreadsheet'  => ImageIcon.new('src/icons/file_xls_large.png'),
    'presentation' => ImageIcon.new('src/icons/file_ppt_large.png'),
  }
  
  def initialize(driver, backups)
    @driver = driver
    @backups = backups
    @files = ListModel.new
    
    @main_frame = Swing::Build.new(JFrame, :x){}.build("Simple Draw") do |c|
      c.add backup_now_panel, N
      c.add main_panel, C
    end
    @main_frame.pack
    @main_frame.default_close_operation = JFrame::EXIT_ON_CLOSE
    
    @backups.contents_changed
    update_backups
  end
  
  def frame
    @main_frame
  end
  
  def backup_complete
    @backups_list.selected_index = 0
  end
  
  def update_backups
    if @backups.empty?
      @main_deck.get_layout.show @main_deck, 'empty'
    else
      @main_deck.get_layout.show @main_deck, 'panel'
    end
  end
  
  private
    def backup_now_panel
      panel :backup_now, :last_backup do |c, i|
        c.backup_now  =  b("Backup Now")
        c.last_backup =  last_backup_label
        
        i.backup_now = a{ @driver.backup_now }
      end
    end
  
    def main_panel
      JPanel.new.tap do |deck|
        deck.layout = CardLayout.new
        @main_deck = deck
        JPanel.new.tap do |jp|
          deck.add jp, "panel"
          jp.layout = BoxLayout.new(jp, BoxLayout::X_AXIS)
          jp.add backups_panel #, W
          jp.add backup_panel  #, C
          jp.add file_panel    #, E
          jp.border = EmptyBorder.new(10,10,10,10)
        end
        
        JPanel.new.tap do |jp|
          deck.add jp, "empty"
          jp.add( Swing::LEL.new JPanel, '[icon|<text]' do |c,i|
            c.icon = JLabel.new(ImageIcon.new('src/icons/gdocs.png'))
            c.text = JTextArea.new.tap do |ta|
              ta.text = "\n\nYour Google Docs aren't backed up!"
              ta.font = Font.new("Sans Serif", Font::BOLD, 18)
              ta.background = jp.background
            end
          end.build)
        end
      end
    end
  
    def backup_panel
      JPanel.new.tap do |deck|
        deck.layout = CardLayout.new
        @backup_deck = deck
        
        JPanel.new(BorderLayout.new).tap do |jp|
          deck.add jp, "panel"
          jp.add title_panel("<html><b><font size='4'>Details"), N
          jp.add backup_details, C
          jp.border = EmptyBorder.new(10,10,10,10)
          jp.preferred_size = d(300, 400)
        end
        
        JPanel.new.tap do |jp|
          deck.add jp, "empty"
          jp.add( Swing::LEL.new JPanel, '[icon|<text]' do |c,i|
            c.icon = JLabel.new(ImageIcon.new('src/icons/arrow_left.png')).tap do |label|
              label.border = EmptyBorder.new(100,0,0,0)
            end
            c.text = JTextArea.new.tap do |ta|
              ta.text = "\nSelect a backup to see more info"
              ta.font = Font.new("Sans Serif", Font::BOLD, 16)
              ta.background = jp.background
              ta.border = EmptyBorder.new(86,0,0,0)
            end
          end.build)
          
          deck.get_layout.show deck, "empty"
        end
      end
    end
  
    def backup_details
      JPanel.new(BorderLayout.new).tap do |jp|
        jp.add backup_details_fields, N
        jp.add backup_files, C
        jp.preferred_size = d(400, 400)
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
      JScrollPane.new(
        @files_list = JList.new(@files).tap do |list|
          list.addListSelectionListener(proc{|sym, args|
            change_file_pane
          }.to_listener(:list_selection))
        end
      )
    end
  
    def number_of_files_label
      @number_of_files_label = JLabel.new.tap do |label|
        @files.addListDataListener(proc{
          label.text = "<html><i>#{@files.size} files backed up"
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
        jp.add title_panel("<html><b><font size='5'>Previous Backups"), N
        jp.add backups_list, C
        jp.add( panel(:restore, :delete) { |c,i|
          c.delete = b "Delete"
          i.delete = a{ delete_backups } 
        }, S)
        jp.preferred_size = d(175,300)
      end
    end
    
    def backups_list
      JScrollPane.new(
        @backups_list = JList.new(@backups).tap do |list|
          list.addListSelectionListener(proc{|sym, args|
            change_backup_pane
          }.to_listener(:list_selection))
        end
      )
    end
  
    def file_panel
      JPanel.new.tap do |jp|
        jp.layout = BoxLayout.new(jp, BoxLayout::Y_AXIS)
        jp.add file_title
        jp.add file_details
        jp.add file_preview
        jp.preferred_size = d(300, 400)
      end
    end
  
    def file_title  
      Swing::LEL.new JPanel, '[^icon|<^*title]' do |c,i|
        c.icon = JLabel.new.tap do |label|
          label.icon = FILE_ICONS['document']
          @title_icon_label = label
        end
        c.title = JTextArea.new.tap do |ta|
          @file_title_field = ta
          ta.line_wrap = true
          ta.background = JPanel.new.background
          ta.font = ta.font.derive_font(ta.font.style ^ Font::BOLD)
        end
      end.build
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
      end
    end
    
    def change_backup_pane
      if current_backup
        @components["date_field"].text = current_backup.timestamp.strftime Time::FORMAT[:long]
        @components["total_size_field"].text = current_backup.size.to_human_file_size
      
        @files.clear 
        @files.concat current_backup.files
        
        @backup_deck.get_layout.show @backup_deck, "panel"
      else
        @backup_deck.get_layout.show @backup_deck, "empty"
        #show other deck?
      end
    end
    
    def change_file_pane
      if current_file
        @components["type_field"].text = current_file.type
        @components["author_field"].text = current_file.authors
        @components["last_viewed_field"].text = current_file.last_viewed.try(:time_ago_human) || "never"
        @components["can_edit_field"].text = current_file.can_edit? ? 'yes' : 'no'
        @components["size_field"].text = current_file.size.to_human_file_size
      
        @file_title_field.text = current_file.title
        @title_icon_label.icon = FILE_ICONS[current_file.type]
      else
        #show other deck?
      end
    end
    
    def current_file
      i = @files_list.get_selected_index
      i >= 0 ? @files[i] : nil
    end
    
    def current_backup
      i = @backups_list.get_selected_index
      i >= 0 ? @backups[i] : nil
    end
    
    def delete_backups
      if JOptionPane::YES_OPTION == JOptionPane.showConfirmDialog(@frame, "Are you sure you want to delete these backups? This cannot be undone.", "Are you sure?", JOptionPane::YES_NO_OPTION)
        @driver.delete_backups @backups_list.selected_indices.map{|i| @backups[i] }
        @backups_list.clear_selection
      end
    end
end