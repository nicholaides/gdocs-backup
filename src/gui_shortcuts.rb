module GUIShortcuts
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy

  N = BorderLayout::NORTH
  S = BorderLayout::SOUTH
  E = BorderLayout::EAST
  W = BorderLayout::WEST
  C = BorderLayout::CENTER
  
  def d(x,y)
    Dimension.new(x,y)
  end
  
  def all_components_of(c)
    c.components + c.components.map{|c| all_components_of(c) }.flatten
  end

  def a(&block)
    { :action => block.to_proc }
  end

  # convenience method for creating JLables
	def l(text="", name="")
    JLabel.new(text) #.tap{|jl| jl.name = name }
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
  
  def panel(*args, &block)
    Swing::Build.new(JPanel, *args, &block).build
  end
  
  def two_column_layout(*args)
    args.map{|a| "[<#{a}_l|<*#{a}]"}.join
  end
  
  def two_column_panel(*args)
    @components ||= {}
    
    layout = two_column_layout(*args)
    Swing::LEL.new JPanel, layout do |c,i|
      args.each do |a|
        @components["#{a}_label"] = c.send("#{a}_l=",  l( "<html><b>" + a.to_s.gsub(/_/, ' ').capitalize ))        
        @components["#{a}_field"] = c.send("#{a}=", l(a.to_s, a.to_s))
      end
    end.build
  end
  
  def title_panel(text, &block)
    JPanel.new(FlowLayout.new(FlowLayout::LEFT)).tap do |jp|
      label = l(text)
      jp.add label
      yield label if block_given?
    end
  end
end
