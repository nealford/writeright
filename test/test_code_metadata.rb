require "test/unit"

require File.dirname(__FILE__) + "/.." + "/lib/code_metadata"
require 'rubygems'

class TestCodeMetadata < Test::Unit::TestCase
  CODE_FORMAT_WITH_JUST_FILE_AND_LANG = 
    ["<!-- code file=\"daily_logs.rb\" lang=\"ruby\" -->",
     "<!--code file=\"daily_logs.rb\" lang=\"ruby\" -->",
     "<!--     code      file = \"daily_logs.rb\"    lang = \"ruby\" -->"]
     

  def test_regex_unsuccessful
    CODE_FORMAT_WITH_JUST_FILE_AND_LANG.each do |l|
      assert_raise Exception do
        cm = CodeMetadata.new(l.sub("file", "foo"))
      end
    end
  end

  def test_does_code_line_have_sections
    ["<!-- code file=\"foo.java\" lang=\"java\" part=\"begin\" -->"].each do |l|
      cm = CodeMetadata.new(l)
      assert cm.has_parts?
    end
  end

  def test_regex_for_parsing_out_code_chunks_for_file_and_part
    ["<!-- code file=\"daily_logs.rb\" lang=\"ruby\" part=\"begin\"-->",
     "<!--code file=\"daily_logs.rb\" lang=\"ruby\" part=\"begin\"-->",
     "<!--     code      file = \"daily_logs.rb\"    lang = \"ruby\"        part = \"begin\" -->"].each do |l|
      cm = CodeMetadata.new(l)
      assert cm.success
      assert_equal "daily_logs.rb", cm.file_name
      assert_equal "ruby", cm.lang
      assert_equal  "begin", cm.part
    end
  end

  def test_metadata_reports_invalid_code_line
    ["<!-- coe file=\"foo.rb\" -->",
     "<!-- code fle=\"foo.rb\" -->",
     "<!-- code -->"].each do |line|
      assert_raise Exception do
        c = CodeMetadata.new(line)
      end
    end
  end

  def test_regex_for_parsing_out_code_chunks_for_just_a_file
    CODE_FORMAT_WITH_JUST_FILE_AND_LANG.each do |l|
      cm = CodeMetadata.new(l)
      assert cm.success
      assert_equal "daily_logs.rb", cm.file_name
      assert_equal "ruby", cm.lang
    end
  end

  def test_that_paths_are_harvested_correctly
    ["<!-- code file=\"./file/with/lots/of/paths/foo.java\" lang=\"java\" -->"].each do |l|
      cm = CodeMetadata.new(l)
      assert_equal "./file/with/lots/of/paths/foo.java", cm.file_name
    end
  end


end
