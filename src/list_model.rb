# Mike Nicholaides
# mike.nicholaides@gmail.com
# CS338: GUI, Assignment 2

require 'java'
require 'facets/core/facets'

# listmodel for the jlist of shapes
#
# proxies a ruby array (@data) via method_missing. ruby rocks
class ListModel
  include javax.swing.ListModel
  
  def initialize
    @listeners = []
    @data = []
  end
  
  #
  # implementing the ListModel interface
  #
  def addListDataListener(l)
    @listeners << l
  end
  
  def removeListDataListener(l)
    @listeners.delete l
  end
  
  def getSize
    @data.size
  end
  
  def getElementAt(*args)
    @data[*args]
  end
  
  def contents_changed
    @listeners.each do |listener|
      listener.contentsChanged(javax.swing.event.ListDataEvent.new(self, javax.swing.event.ListDataEvent::CONTENTS_CHANGED, 0, @data.size))
    end
  end
  
  # proxy to our @data array
  def method_missing(method, *args, &block)
    ret_val = @data.send(method, *args, &block)
    
    if %w[<< []= clear delete delete_at delete_if fill insert push pop shift unshift replace].include? method.to_s or method.to_s =~ /\!$/
      contents_changed
    end
      
    ret_val
  end
end