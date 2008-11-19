require "test/unit"

require "../lib/bootstrap" 
require "fileutils" 
require 'rubygems'
require 'dust'
require 'mocha'

class FakeStdOut
  attr_reader :output
  
  def initialize
    @output = ""
  end
  def write(s)
    @output += s
  end
end

unit_tests do
  TEST_DIR = "test_structure"  
  
  test "bootstrap project with no infrastructure" do
    FileUtils.mkdir TEST_DIR
    b = BootStrap.new TEST_DIR
    b.start_project
    BootStrap::LEVELS.each do |d|
      assert File.exists? "#{TEST_DIR}/#{d}"
    end    
  end
  
  test "existing infrastructure accomodation" do 
    expected = <<-'END'
test_structure/branches exists
test_structure/current exists
test_structure/snapshots exists
test_structure/current/code exists
test_structure/current/figs exists
test_structure/current/pdf exists
test_structure/current/figs/incoming exists
test_structure/current/figs/master exists
test_structure/current/figs/print exists
test_structure/current/figs/web exists
END
    FileUtils.mkdir TEST_DIR
    b = BootStrap.new TEST_DIR
    b.start_project    
    BootStrap::LEVELS.each do |d|
      assert File.exists? "#{TEST_DIR}/#{d}"
    end
    old_stdout = $stdout
    $stdout = FakeStdOut.new
    begin
      b.start_project  
      assert_equal($stdout.output, expected);
    ensure
      $stdout = old_stdout
    end
    
  end
  
  def teardown
    BootStrap::LEVELS.each do |d|
      path = "#{TEST_DIR}/#{d}"
      FileUtils.rm_rf path if File.exists? path
    end    
    FileUtils.rm_rf "#{TEST_DIR}"
  end
  
end
