require 'profligacy/swing'
require 'profligacy/parser'
require 'profligacy/swing-layout'

module Profligacy
  include_package 'profligacy'

  # This is passed to the parser to scan over the LEL expression
  # initially and pull out the list of cell names that are going
  # to be used.  The result of this scan is then used to create
  # the contents and interactions structs.
  class LELNameScanner
    include Profligacy::LELParser::LELEventListener
    attr_reader :children

    def initialize
      @children = []
    end

    def id(name)
      @children << name.to_sym
    end

    def method_missing(symb, *args)
      #ignored
    end
  end

  # Used by Swing::Build as the listener for LELParser which configures
  # a GroupLayout from the LEL expression.  See http://ihate.rubyforge.org/profligacy/lel.html
  # for instructions on how to use LEL.
  class LELGroupLayout 
    include Profligacy::LELParser::LELEventListener

    include_package 'org.jdesktop.layout'
    include_class 'java.lang.Short'

    # Takes a GroupLayout and the list of components to organize inside it.
    def initialize(layout, components)
      @layout = layout
      @hgroup = @layout.createSequentialGroup
      @vgroup = @layout.createSequentialGroup
      @vertical = nil
      @horizontals = []
      @components = components

      alignments_reset
      widths_reset
      heights_reset
      horizontals_reset
    end

    # Called when a '|' token is hit by the LELParser.
    def col
      horizontals_push; alignments_reset ; widths_reset
    end

    # Called when a '[' token is hit by the LELParser.
    def ltab
      horizontals_reset
      @vertical = @layout.createBaselineGroup(true, false)
    end

    # Called when a '^' or '.' token is hit by the LELParser.
    def valign(dir)
      case dir
      when "^" then @valign = GroupLayout::LEADING
      when "." then @valign = GroupLayout::TRAILING
      else
        raise "Invalid Vertical Alignment: #{dir}"
      end
    end

    # Called when a name/id for a cell token is hit by the LELParser.
    def id(name)
      h = horizontals_cur
      component = @components[name]

      if component
        @vertical.add(@valign, component, GroupLayout::DEFAULT_SIZE, @height, @max)
        h.add(@halign, component, GroupLayout::DEFAULT_SIZE, @width, @max)
      elsif name != "_"
        raise "Cell named '#{name}' does not have a component set during build."
      end
    end

    # Called when a ']' token is hit by the LELParser.
    def row
      @vgroup.add(@vertical);
      alignments_reset ; widths_reset ; heights_reset
    end

    # Called when a '>' or '<' token is hit by the LELParser.
    def align(direction)
      case direction
      when "<" then @halign = GroupLayout::LEADING
      when ">" then @halign = GroupLayout::TRAILING
      else
        raise "Invalid Horizontal Alignment: #{direction}"
      end
    end

    # Called when a '(#)' is hit (with # being some number) by the LELParser.
    def setwidth(width)
      @width = width
    end

    # Called when a height is added to '(#,#)' expressions in the LELParser.
    def setheight(height)
      @height = height
    end

    # Called when the cell should expand via a '*' token.
    def expand
      @max = Short::MAX_VALUE
    end

    # Called when it's done parsing, and whether there was an error.
    def finished(error)
      if !error
        @layout.setHorizontalGroup(@hgroup);
        @layout.setVerticalGroup(@vgroup);
      end
    end

    private

    # Resets the vertical and horizontal alignments when the end of a or row is
    # passed.
    def alignments_reset
      @valign = GroupLayout::CENTER
      @halign = GroupLayout::CENTER
    end

    # Same as alignments_reset but for the widths.
    def widths_reset
      @width = GroupLayout::DEFAULT_SIZE
      @max = GroupLayout::DEFAULT_SIZE
    end

    # Resets the heights when the current row ends.
    def heights_reset
      @height = GroupLayout::DEFAULT_SIZE
    end

    # The horizontal cells are organized in a dynamic array that's expanded as
    # more are encountered.  Just like an old typewriter, when the current row
    # ends the next column to work on is "reset" by starting at the first one.
    # This method just resets it to be the next one.
    def horizontals_reset
      @htop = 0
    end

    # Adds a new horizontal cell onto the list of cells being worked on.
    def horizontals_push
      @htop += 1
    end

    # Either makes a new horizontal cell for the curent operation to work on,
    # or just returns the existing one.
    def horizontals_cur
      if !@horizontals[@htop]
        @horizontals[@htop] = @layout.createParallelGroup()
        @hgroup.add(@horizontals[@htop])
      end

      @horizontals[@htop]
    end

  end


  module Swing

    # Layout Expression Language is a small regex like wiki language used to
    # specify complex layouts in a tiny amount of space.  The language is based on
    # a Ragel based parser that configures a Swing GroupLayout with the right
    # options to produce the desired effect.  An example of LEL is:
    #
    # 
    #  @layout = "
    #   [ label_1         | label3      ]
    #   [ (300,300)*text1 | (150)people ]
    #   [ <label2         | _           ]
    #   [ .message        | ^buttons    ]"
    #
    # Which will produce a panel where you can place components.  Otherwise it works
    # exactly like Swing::Build except you pass the LEL expression in to the constructor
    # instead of an array of symbols.
    #
    # See http://ihate.rubyforge.org/profligacy/lel.html for more instructions.
    class LEL < Build
      include_package 'org.jdesktop.layout'
      attr_reader :prefs

      def initialize(type, expr)
        @expr = expr
        @container_class = type
        @parser = LELParser.new
        names = LELNameScanner.new
        @prefs = {
          :auto_create_gaps => true, 
          :auto_create_container_gaps => true, 
          :honors_visibility => true, 
          :pack => true, 
          :visible => true,
          :args => []
        }
        parse(names)
        setup_children_and_interactions(names.children)
        yield @contents, @interactions
      end

      def build(prefs={})
        prefs = @prefs.merge prefs

        @container = @container_class.new(*(prefs[:args]))
        pane = @container.respond_to?(:content_pane) ? @container.content_pane : @container
        layout = GroupLayout.new pane
        @container.layout = layout
        layout.autocreate_gaps = prefs[:auto_create_gaps] 
        layout.autocreate_container_gaps = prefs[:auto_create_container_gaps] 
        layout.honors_visibility = prefs[:honors_visibility]

        parse(LELGroupLayout.new(layout, @contents))

        @children.each {|child|
          configure_interactions_for(child,@contents[child]) if @contents[child]
        }

        yield @container if block_given?

        @container.pack if (prefs[:pack] && @container.respond_to?(:pack))
        @container.visible = prefs[:visible] if @container.respond_to? :visible
        @container
      end

      private

      def parse(listener)
        if !@parser.scan(@expr, listener)
          raise "LEL parsing error at #{@parser.position} from: '#{@expr[@parser.position-1 .. @parser.position + 30]}' ..."
        end
      end
    end
  end
end
