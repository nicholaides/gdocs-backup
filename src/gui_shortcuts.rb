module GUIShortcuts
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  
  def d(x,y)
    Dimension.new(x,y)
  end
  
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
  
  def p(*args, &block)
    Swing::Build.new JPanel, *args, &block 
  end
  
  N = BorderLayout::NORTH
  S = BorderLayout::SOUTH
  E = BorderLayout::EAST
  W = BorderLayout::WEST
  C = BorderLayout::CENTER
end
