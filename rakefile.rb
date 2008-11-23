# create a directory and put this Rake file there (along with bootstrat.rb and credentials.rb)
# 'credentials.rb' contains the constants USERNAME, which is your Subversion longin name, and PASSWORD, which is you Subversion password
# run bootstrap to create directory structure
# start writing chapters in current
# You must have XMLLine installed on your machine for the validation stuff to work

require 'rake'
#require 'credentials'
require 'lib/bootstrap.rb'
#SVN = "svn --username #{USERNAME} --password #{PASSWORD} "
SVN_GET_RECENT_CHANGED_FILES = "svn stat | grep xml | sed 's/M[ ]*//'"

task :default => [:tests]

task :tests do
  system "testrb test/*"
end


# start a new project directory structure
# shouldn't hurt anything if run against an existing project
task :bootstrap do
  BootStrap.new.start_project
end

# Subversion update
task :up do
  system SVN + 'up'
end

# Subversion checkin without validation
task :ci do
  sh 'echo Doing a check in WITHOUT validating'
  system SVN + "ci -m 'Updates'"
end

# Subversion checkin that adds the magic O'Reilly message to tell it's server to generate a PDF and dump it in the repository
task :pdf => :valid do
  system SVN + "ci -m 'orm:commitpdf'"
end
   
# Subversion status
task :stat do
  system SVN + 'stat'
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
