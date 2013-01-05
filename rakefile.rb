# create a directory and put this Rake file there (along with bootstrat.rb and credentials.rb)
# 'credentials.rb' contains the constants USERNAME, which is your Subversion longin name, and PASSWORD, which is you Subversion password
# run bootstrap to create directory structure
# start writing chapters in current
# You must have XMLLint installed on your machine for the validation stuff to work

require 'rake'
#require 'credentials'
#SVN = "svn --username #{USERNAME} --password #{PASSWORD} "
SVN_GET_RECENT_CHANGED_FILES = "svn stat | grep xml | sed 's/M[ ]*//'"

task :default => [:tests]

task :tests do
  system "testrb test/*"
end


# This task only validates recently edited files. 
task :recent do
  system "clear; echo You\'ll likely get some xref errors because I\'m not doing the whole thing -- don\'t panic"
  system "#{SVN_GET_RECENT_CHANGED_FILES} | xargs echo linting"
  system "#{SVN_GET_RECENT_CHANGED_FILES} | xargs xmllint --postvalid --xinclude --noout"
end
 
# validates the entire book -- will take a while!
task :valid do
  sh 'clear'
  raise "book is not valid" unless system "xmllint --postvalid --xinclude --noout current/book.xml" 
end
   
# open the PDF from the repository, updating to the most recent version
task :open => [:up, :view] do
end

# just view the book, don't get the latest version
task :view do
  sh 'open ./current/pdf/book.xml.pdf'
end 
