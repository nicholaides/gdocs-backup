Mike Nicholaides
mike.nicholaides@gmail.com
CS338: GUI, Assignment 2

For my sanity, this assignment was written in Ruby, to run on JRuby.
I wouldn't assume you have JRuby installed, so here are a bunch of options for
 running my program.


To run on tux, you may be able to just do this:
-----------------------------------------------
java -jar /home/nmn25/public_html/gui_ass2/SimpleDraw.jar


To run on your machine
----------------------
download and unzip http://www.cs.drexel.edu/~nmn25/gui_ass2/SimpleDraw.zip
run the jar file, via
  java -jar SimpleDraw.jar
    or
  double click SimpleDraw.jar


To look at the source
---------------------
downoad and unzip http://www.cs.drexel.edu/~nmn25/gui_ass2/ass2.zip


To run from source (this requires jruby)
----------------------------------------
jruby src/simple_draw_main.rb


To build (requires jruby, and the rawr gem)
-------------------------------------------
rake rawr:jar


To run from build
-----------------
java -jar package/jar/SimpleDraw.jar

