# Mike Nicholaides
# mike.nicholaides@gmail.com
# CS338: GUI, Assignment 2

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../lib/ruby'

require 'profligacy/swing'
require 'profligacy/lel'
require 'facets/core/facets'

require 'gui_shortcuts'
require 'list_model'


class Driver
  def initialize
    @main_window = MainWindow.new
  end
end

class MainWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  include GUIShortcuts
  
  def initialize
    main_frame = Swing::Build.new(JFrame, :x){}.build("Simple Draw") do |c|
      c.add backups_panel, W
      c.add backup_panel, C
      c.add file_panel, E
    end
    main_frame.default_close_operation = JFrame::EXIT_ON_CLOSE
  end
  
  def backup_panel
    JPanel.new(BorderLayout.new).tap do |jp|
      jp.add l("Backup Details"), N
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
      c.date_l = l('Date')
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
  
  def backups_panel
    @backups = ListModel.new
    @backups << 'Stuff' << 'Grapes'
    
    JPanel.new(BorderLayout.new).tap do |jp|
      jp.add l("Previous Backups"), N
      jp.add JList.new(@backups), C
      jp.add( p(:restore, :delete) { |c,i|
        c.restore = b "Restore"
        c.delete  = b "Delete"
      }.build, S)
    end
  end
  
  def file_panel
    JPanel.new.tap do |jp|
      jp.layout = BoxLayout.new(jp, BoxLayout::X_AXIS)
      jp.add file_title
    end
  end
  
  def file_title
    JPanel.new.tap do |jp|
      jp.add l("File Title...")
    end
  end
end


# Main driver
class SimpleDraw
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  
  def initialize
    @shapes = ListModel.new #custom listModel that simply proxies an Array
    
    #
    # CREATING MAIN FRAME
    #
    buttons_panel = Swing::Build.new JPanel, :add, :edit, :remove do |c,i|
      c.add    = b "Add"
      c.edit   = b "Edit"
      c.remove = b "Remove"
      
      i.add    = { :action => proc{ add_action    } }
      i.edit   = { :action => proc{ edit_action   } }
      i.remove = { :action => proc{ remove_action } }
    end.build
    
    @jlist = JList.new(@shapes)
    @jlist.preferred_size = Dimension.new(300, 300)
    
    drawing_panel = ShapesPanel.new #custom component that draws the shapes
    drawing_panel.init(@shapes)
    drawing_panel.preferred_size = Dimension.new(300, 300)
    
    main_frame = Swing::Build.new(JFrame, :x){}.build("Simple Draw") do |c|
      c.add @jlist,        BorderLayout::WEST 
      c.add drawing_panel, BorderLayout::CENTER
      c.add buttons_panel, BorderLayout::SOUTH
    end
    main_frame.default_close_operation = JFrame::EXIT_ON_CLOSE
    
    
    
    #call my private method to create tabs
    # tabs use the Profligacy library's Layout Expression Language
    # isn't that nice?
    add_tab Square,
      "[ >center_x_l | center_x_t     ]
       [ >center_y_l | center_y_t     ]
       [ >size_l     | size_t         ]
       [ fill_check  | color_selector ]" do |c,i|
       
      c.center_x_l = l "Center X" #using private method l to make JLabels easy
      c.center_y_l = l "Center Y"
      c.size_l     = l "Size"

      c.fill_check     = fill_check  #using private method to make the Fill checkboxes easy
      c.color_selector = color_selector  #using private method to make the color selectors easy

      c.center_x_t = t 'center_x' #private method t for creating JTextFields
      c.center_y_t = t 'center_y'
      c.size_t     = t 'size'
    end
    
    
    add_tab Rectangle,
      "[ >center_x_l | center_x_t     ]
       [ >center_y_l | center_y_t     ]
       [ >height_l   | height_t       ]
       [ >width_l    | width_t        ]
       [ fill_check  | color_selector ]" do |c,i|
       
      c.center_x_l = l "Center X"
      c.center_y_l = l "Center Y"
      c.height_l   = l "Height"
      c.width_l    = l "Width"
      
      c.fill_check     = fill_check
      c.color_selector = color_selector
      
      c.center_x_t = t 'center_x'
      c.center_y_t = t 'center_y'
      c.height_t   = t 'height'
      c.width_t    = t 'width'
    end
    
    
    add_tab Circle,
      "[ >center_x_l | center_x_t     ]
       [ >center_y_l | center_y_t     ]
       [ >radius_l   | radius_t       ]
       [ fill_check  | color_selector ]" do |c,i|
       
      c.center_x_l = l "Center X"
      c.center_y_l = l "Center Y"
      c.radius_l   = l "Radius"
      
      c.fill_check     = fill_check
      c.color_selector = color_selector
      
      c.center_x_t = t 'center_x'
      c.center_y_t = t 'center_y'
      c.radius_t   = t 'radius'
    end
    
    
    add_tab Oval,
      "[ >center_x_l | center_x_t     ]
       [ >center_y_l | center_y_t     ]
       [ >radius_x_l | radius_x_t     ]
       [ >radius_y_l | radius_y_t     ]
       [ fill_check  | color_selector ]" do |c,i|
       
      c.center_x_l = l "Center X"
      c.center_y_l = l "Center Y"
      c.radius_x_l = l "Radius X"
      c.radius_y_l = l "Radius Y"
      
      c.fill_check     = fill_check
      c.color_selector = color_selector
      
      c.center_x_t = t 'center_x'
      c.center_y_t = t 'center_y'
      c.radius_x_t = t 'radius_x'
      c.radius_y_t = t 'radius_y'
    end
    
    add_tab Line,
      "[ >endpoint_1_x_l | endpoint_1_x_t ]
       [ >endpoint_1_y_l | endpoint_1_y_t ]
       [ >endpoint_2_x_l | endpoint_2_x_t ]
       [ >endpoint_2_y_l | endpoint_2_y_t ]
       [ color_l         | color_selector ]" do |c,i|
       
      c.endpoint_1_x_l = l "Endpoint 1 X"
      c.endpoint_1_y_l = l "Endpoint 1 Y"
      c.endpoint_2_x_l = l "Endpoint 2 X"
      c.endpoint_2_y_l = l "Endpoint 2 Y"

      c.color_l = l "Color"
      
      c.color_selector = color_selector
      
      c.endpoint_1_x_t = t 'endpoint_1_x'
      c.endpoint_1_y_t = t 'endpoint_1_y'
      c.endpoint_2_x_t = t 'endpoint_2_x'
      c.endpoint_2_y_t = t 'endpoint_2_y'
    end
    
    
    buttons_panel = Swing::Build.new JPanel, :save, :cancel do |c,i|
      c.save   = b "Save"
      c.cancel = b "Cancel"

      i.save   = { :action => proc{ save_action   } }
      i.cancel = { :action => proc{ cancel_action } }
    end.build
    
    # Make a dialog the ol' fashioned way
    @dialog = JDialog.new main_frame, true
    @dialog.visible = false
    @dialog.preferred_size = Dimension.new(350, 350)
    @dialog.add @tabbed_pane, BorderLayout::CENTER
    @dialog.add buttons_panel, BorderLayout::SOUTH
    @dialog.pack
    
    #Set all checkbox's names to "fill"
    all_dialog_components.grep(JCheckBox).each{|c| c.name = 'fill' }
    
    #Set all combobox's names to "color"
    all_dialog_components.grep(JComboBox).each{|c| c.name = 'color' }
  end
  
  private
    # creates a tab and adds it to the tabbed pane
    # 
    # shape_class: The class of the shape, just so we can put our list of shape classes in the correct order
    # layout: the LEL string that describes the layout of the panel
    # block: passed to Profligacy's LEL builder
    def add_tab(shape_class, layout, &block)
      @tabbed_pane ||= JTabbedPane.new
      @shape_classes ||= []
    
      panel = Swing::LEL.new JPanel, layout, &block
      tab = JPanel.new
      tab.add panel.build, BorderLayout::CENTER
      @tabbed_pane.add tab, shape_class.name
      @shape_classes << shape_class
    end
  
    # handles "Save" button action
    def save_action
      if ensure_integers
        shape = create_shape
        if @action == :add
          @shapes << shape
        else
          @shapes[@jlist.get_selected_index] = shape
        end
        @dialog.hide
        clear_dialog
      end
    end
  
    # handles "Cancel" button action
    def cancel_action
      @dialog.hide
      clear_dialog
    end
  
    # handles "Add" button action
    def add_action
      clear_dialog
      @action = :add
      @dialog.show
    end
  
    # handles "Edit" button action
    def edit_action
      if @jlist.selected_value
        fill_dialog
        @action = :edit
        @dialog.show
      end
    end
  
    # handles "Remove" button action
    def remove_action
      @shapes.delete @jlist.selected_value
    end
  
    # fills the dialog's input components with values from the selected shape
    # the component's names match the shape instances accessors
    # that makes is easy to fill in the names
    def fill_dialog
      shape = @jlist.selected_value
      @tabbed_pane.selected_index = @shape_classes.index(shape.class)
    
      all_components_of(@tabbed_pane.selected_component).each do|c|
        case c
        when JTextField
          c.text = shape.send(c.name).to_s
        when JCheckBox
          c.selected = shape.fill
        when JComboBox
          c.selected_item = shape.color
        end
      end
    end
  
    # shows error message if entered values are invalid
    # returns true if they are valid, false otherwise
    def ensure_integers
      values = all_components_of(@tabbed_pane.selected_component).grep(JTextField).map{|c| c.text }
    
      if values.any?{|v| v.nil? or v.gsub(/\s/,'') == '' or v =~ /\D/ }
        JOptionPane.showMessageDialog(@dialog, "All text values must be integers and cannot be blank.", "Error", JOptionPane::ERROR_MESSAGE); 
        false
      else
        true
      end
    end
  
    # create a shape instance from the values in the text field
    # the shape's attributes are easily filled, becaue the accessor names
    #  match up with the swing components' names
    #
    # returns the created shape
    def create_shape
      shape = selected_shape_class.new
      all_components_of(@tabbed_pane.selected_component).
        select{|c| c.name and shape.respond_to? c.name }.
        map{ |c| 
          value = case c
            when JTextField; c.text.to_i
            when JCheckBox;  c.is_selected?
            when JComboBox;  c.selected_item
          end
        
          [c.name, value]
        }.
        each{|name, value| shape.send("#{name}=", value) }
      
      shape
    end
  
    # gets the class indicated by the selected tab
    #
    # returns a class of the shape to be created
    def selected_shape_class
      @shape_classes[@tabbed_pane.selected_index]
    end
  
    # resets the dialog and clears all inputs
    def clear_dialog
  	  all_dialog_components.grep(JTextField).each{|c| c.text = "" }
  	  all_dialog_components.grep(JCheckBox).each{|c| c.selected = false }
  	  all_dialog_components.grep(JComboBox).each{|c| c.selected_index = 0 }
  	  @tabbed_pane.selected_index = 0
    end
	
	  # returns list of all components that are ancestors of the diolog
  	def all_dialog_components
  	  @all_dialog_components ||= all_components_of(@dialog)
    end
  
    # returns list of all components that are ancestors of a given component
    # c: component whose ancestors we want
    def all_components_of(c)
      c.components + c.components.map{|c| all_components_of(c) }.flatten
    end
	
	  # convenience method for creating JLables
  	def l(*args)
      JLabel.new *args
    end
  
    # convenience method for creating JTextFields
    # 
    # name: the JTextField's name is set to this
    def t(name, *args)
      field = JTextField.new *args
      field.name = name
      field
    end
  
    # convenience method for creating JButtons
    def b(*args)
      JButton.new *args
    end
  
    # convenience method for creating a Color selector
    def color_selector
      JComboBox.new(%w[Black Blue Green Red Yellow].to_java :String)
    end
  
    # convenience method for creating Fill checkboxes
    def fill_check
      JCheckBox.new("Fill")
    end
end


SwingUtilities.invoke_later proc{ Driver.new }.to_runnable