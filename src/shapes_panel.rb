# Mike Nicholaides
# mike.nicholaides@gmail.com
# CS338: GUI, Assignment 2

require 'java'

# custom component that draws the shapes
# 
# the ShapesPanel adds itself as a listener to the listmodel, and repaints
#  when something changes
class ShapesPanel < javax.swing.JPanel
  include_package 'java.awt'
  
  # classes that inherit from java classes have to do something fancy for
  #  their constructors. screw that. this shoud be called after instantiation
  #
  # shapes_list: ListModel of shapes
  def init(shapes_list)
    @shapes = shapes_list
    @shapes.addListDataListener(self)
  end
  
  # overridden to draw my shapes. i gotta draw my shapes
  def paintComponent(g)
    g.color = Color.white
    g.fill_rect 0, 0, 1000, 1000
    
    @shapes.each do |shape|
      g.color = Color.black
      shape.draw(g)
    end
  end
  
  # repaint when the list of shapes changes
  def contentsChanged(*args)
    repaint
  end
end