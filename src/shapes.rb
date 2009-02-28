# Mike Nicholaides
# mike.nicholaides@gmail.com
# CS338: GUI, Assignment 2

require 'java'

# all shapes inherit from this for convenience and DRYness
class Shape
  # draws the shape
  #
  # g: a java.awt.Graphics object
  def draw(g)
    g.color = java.awt.Color.send(color.downcase)
    draw_shape(g)
  end
  
  #convenience methods for the jlist display text
  def fill_s;       fill ? color: 'no fill'                    end
  def prop_s(prop)  "#{prop} #{self.send(prop)}"               end
  def center_s;     "center(#{center_x}, #{center_y})"         end
  
  def to_s;         "#{self.class.name}: #{info.join(', ')}"   end
end


class Square < Shape
  attr_accessor :center_x, :center_y, :size, :fill, :color
 
  def draw_shape(g)
    g.send(fill ? :fill_rect : :draw_rect,  center_x-size/2, center_y-size/2, size, size)
  end
  
  def info; [center_s, prop_s(:size), fill_s]  end
end


class Rectangle < Shape
  attr_accessor :center_x, :center_y, :width, :height, :fill, :color
  
  def draw_shape(g)
    g.send(fill ? :fill_rect : :draw_rect,  center_x-width/2, center_y-height/2, width, height)
  end
  
  def info; [center_s, prop_s(:width), prop_s(:height), fill_s]  end
end


class Circle < Shape
  attr_accessor :center_x, :center_y, :radius, :fill, :color
  
  def draw_shape(g)
    g.send(fill ? :fill_oval : :draw_oval,  center_x-radius, center_y-radius, radius*2, radius*2)
  end
  
  def info; [center_s, prop_s(:radius), fill_s]  end
end


class Oval < Shape
  attr_accessor :center_x, :center_y, :radius_x, :radius_y, :fill, :color
  
  def draw_shape(g)
    g.send(fill ? :fill_oval : :draw_oval,  center_x-radius_x, center_y-radius_y, radius_x*2, radius_y*2)
  end
  
  def info; [center_s, prop_s(:radius_x), prop_s(:radius_y), fill_s]  end
end


class Line < Shape
  attr_accessor :endpoint_1_x, :endpoint_1_y, :endpoint_2_x, :endpoint_2_y, :color
  
  def draw_shape(g)
    g.draw_line endpoint_1_x, endpoint_1_y, endpoint_2_x, endpoint_2_y
  end
  
  def info; ["(#{endpoint_1_x}, #{endpoint_1_y}) to (#{endpoint_2_x}, #{endpoint_2_y}), #{color}"] end
end