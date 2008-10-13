require 'rubygems'
require 'builder'
require 'builder/xmlmarkup'

x = Builder::XmlMarkup.new
x.declare! :DOCTYPE, :chapter, "PUBLIC", "-//OASIS//DTD DocBook XML V4.4//EN", "http://www.docbook.org/xml/4.4/docbookx.dtd"
x.chapter(:id => "chp.perfect_tools") { |c|
  c.title( "Find the Perfect Tools" )
  c.para(
"Throughout the book thus far, I've shown you examples of using a slew of different tools to solve various problems: batch files, bash scripts (both one-liners and full blown scripts), Windows PowerShell, Ruby, Groovy, sed, awk, and a whole menagerie of big-eyed O'Reilly animals. Now the critical time has come. You've identified a problem that is causing grief and you want to automate it away: which tool do you use? The first tool you'll probably use a a lowly text editor. First, I talk about this perhaps most important tool in your arsenal."
  )
}
puts x.target!
