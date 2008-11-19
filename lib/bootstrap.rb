class BootStrap
  LEVELS = %w(branches current snapshots current/code current/figs 
      current/pdf current/figs/incoming current/figs/master 
      current/figs/print current/figs/web)
  
  def initialize(path=".")
    @path = path
  end
  
  def start_project
    LEVELS.each do |d|
      path = "#{@path}/#{d}"
      if File.exists? path
        puts "#{path} exists"
      else
        FileUtils.mkdir path
      end
    end
  end
end