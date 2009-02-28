require 'java'

import 'javax.swing.SwingUtilities'


# Profligacy is a library that helps to build Swing GUIs without getting the
# way of the huge number of components and options available.  The approach
# taken by Profligacy is to be a purposefully leaky abstraction.  Rather than
# try to cover all the possible configurable options available to Swing, it
# simply attempts to solve three problems:
#
# First, building a swing interface involves mixing the layout construction with the
# widget construction.  This is solved by a few simple builders named
# Swing::Build and Swing::LEL that help organize your components inside a 
# given layout in a way that looks like Ruby and reduces tons of complexity.
#
# Second, using any of the more complex layouts like GridBagLayout or GroupLayout is
# nasty.  This is solved by the Layout Expression Language that uses a wiki syntax
# that matches like a regex and builds any configurable GroupLayout you might need.
# It removes an *insane* amount of code you'd need to write by hand or the need for
# an external tool to configure the layout.
#
# Writing Java callback Listeners and Runnables is a pain in the ass.  This is 
# solved by an ugly hack where Profligacy generates a bunch of Listener -> Proc
# converters for each of the bazillion Listener implementations that SWing loves
# even though they all do the same damn thing anyway.
#
# See http://ihate.rubyforge.org/profligacy/ for more information.
#
module Profligacy 
  module Swing
    include_class 'java.lang.Runnable'
    include_package 'java.awt.event'
    include_package 'javax.swing.event'
    include_package 'javax.swing' 
    include_package 'java.awt'

    # This is used by the added Proc.to_runnable to make a Runnable 
    # interface that just calls a proc anyway.  With this you can
    # do proc { puts "hi" }.to_runnable and pass the result to
    # threads and such.
    class RunnableProc
      include Runnable
      def initialize(&block)
        @block = block
      end

      def run
        @block.call
      end
    end


    # NOTHING TO SEE HERE.  GO AWAY.  THIS CODE IS WRONG WRONG WRONG
    # AND WILL GO AWAY IN THE NEAR FUTURE.
    module Listeners
      AWT_LISTENERS = ["Action","Adjustment","AWTEvent","Component","Container","Focus",
          "HierarchyBounds","Hierarchy","InputMethod","Item","Key","Mouse",
          "MouseMotion","MouseWheel","Text", 
          "WindowFocus","Window","WindowState",]

      SWING_LISTENERS = [ "Ancestor", "Caret", "CellEditor", "Change",
          "Document", "Hyperlink", "InternalFrame", "ListData",
          "ListSelection", "MenuDragMouse", "MenuKey", "Menu",
          "MouseInput", "PopupMenu", "TableColumnModel", "TableModel",
          "TreeExpansion", "TreeModel", "TreeSelection", "TreeWillExpand",
          "UndoableEdit", ]

      horrid_java_sucks_ass_hack = (SWING_LISTENERS + AWT_LISTENERS).collect do |listener|
        "class #{listener}ListenerProc
          include Profligacy::Swing::#{listener}Listener

          def initialize(&block)
            @block = block
          end

          def method_missing(symb, *args)
            @block.call(symb, *args)
          end
        end" 
      end

      module_eval horrid_java_sucks_ass_hack.join("\n")
    end

    # The Swing::Build class doesn't actually do any swing stuff, but instead
    # it organizes the common pattern of constructing components, attaching
    # interaction procs or methods.
    #
    # See the many examples and instructions at http://ihate.rubyforge.org/profligacy/
    # for more information.
    class Build
      attr_accessor :children
      attr_accessor :contents
      attr_accessor :interactions
      attr_accessor :layout
      attr_accessor :container

      include_package 'javax.swing'

      # When you construct a Swing::Build you pass in the container
      # to use as the first argument, and then symbols for the names 
      # of the contents as the rest of the arguments.
      #
      #   ui = Swing::Build.new JFrame, :left, :right, :top do |c,i|
      #     ...
      #   end
      #
      # The Build class doesn't actually do anything with this until
      # you call the Swing::Build.build method.  It just collects up
      # the contents and interactions you attach to the c and i parameters
      # in the block.
      #
      # The c and i parameters stand for contents and interactions and are
      # a Ruby Struct objects that have the names you gave as elements.
      # This means if you try to set one that doesn't exist you'll get an
      # error (which is pretty handy).
      def initialize(*children)
        @container_class = children.shift
        setup_children_and_interactions(children)
        yield @contents, @interactions
      end

      # Build will finally build the container you configured, passing any
      # arguments to that container.  When it's done it returns the resulting
      # container for you to modify.
      #
      # You can also attach a block to the method call that will be called
      # with the container right before it's completed.  This lets you modify
      # it at the right moment.  For example, if you need to set some options
      # to a JFrame right before it's made visible.
      #
      # Finally, it's so common to make containers visible and pack them that
      # this method will do that if the container has those methods.
      def build(*args)
        # create the container they ask for with these args
        @container = @container_class.new *args
        # tack on the layout they wanted
        @container.layout = layout if layout

        # go through all the children, add them on and tack on the callbacks
        @children.each {|child|
          if @contents[child]
            # if this component answers the each call then go through all
            component = @contents[child]
            each_or_one(component) {|c| @container.add(c) }

            configure_interactions_for child, component
          end
        }

        # yield to the caller so that they can configure more before
        # we make it visible and pack it
        yield @container if block_given?

        # even though swing doesn't do this, we do
        @container.pack if @container.respond_to? :pack
        @container.visible = true if @container.respond_to? :visible

        # and now they can do whatever they want to the container
        @container
      end

      # It's kind of a pain to always access ui.contents.thename so
      # the method_missing simply lets you do ui.thename.  Won't work
      # of course if your component is named "build", "children", 
      # "contents", "interactions", "layout", "container" since those
      # exist in the Build object already.
      def method_missing(symb, *args)
        @contents[symb]
      end

      protected

      # allows for a block of code to be run on each element of
      # anything responding to each, or just on one item
      def each_or_one(component)
        if component.respond_to? :each
          component.each {|c| yield c }
        else
          yield component
        end
      end

      def setup_children_and_interactions(children)
        @children = children
        @klass = Struct.new *@children
        @contents = @klass.new
        @interactions = @klass.new
      end

      def configure_interactions_for(child,component)
        actions = @interactions[child]
        # now we tack on the callback
        actions.each { |type, callback|
          each_or_one(component) do |c|
            c.send("add_#{type}_listener", callback.to_proc.to_listener(type))
          end
        } if actions
      end
    end


  end
end

# Modifications to Proc to make the Runnable and Listener conversion easy.
class Proc
  # Takes this proc and converts it to an ListenerProc based on the action name.
  # The name should be one in Profligacy::Listeners and is based on the add_blah_listener
  # method on that component.  So, if you need a ChangeListener you do:
  #
  #   proc {|t,e| puts t }.to_listener(:change)
  #
  # The two parameters are a symbol for the method that Java called on this, and then the
  # event argument.
  def to_listener(action)
    Profligacy::Swing::Listeners.const_get("#{action.to_s.capitalize}ListenerProc").new &self
  end

  # Converts this Proc to a RunnableProc which implements the Runnable interface.
  def to_runnable
    Profligacy::Swing::RunnableProc.new &self
  end
end
