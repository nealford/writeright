require "test/unit"

require File.dirname(__FILE__) + "/.." + "/lib/code_harvest"
require 'rubygems'


class TestCodeHarvest < Test::Unit::TestCase
  CURRENT_DIR = File.dirname(__FILE__)
  TEST_DOCS = "#{CURRENT_DIR}/test_docs" 

  def setup
    @ch = CodeHarvest.new
  end



  def test_can_get_a_line_of_code
    ["<!-- code file=\"foo.java\" lang=\"java\" -->",
     "<!--code  file=\"foo.java\" lang=\"java\" sect=\"beging\" -->",
     "<!--        code     file=-->"].each do |l|
      assert @ch.is_code_line?(l)
    end
  end

  def test_does_not_get_code_lines_that_are_not_code_file_references
    ["code",
     "<!-- check the code for correctnesss -->",
     "<!-- code is broken here -->",
     "<!-- code in file sucks"].each do |l|
      assert ! @ch.is_code_line?(l)
    end
  end


  def test_gets_simple_parts
    expected = <<END_OF_EXPECTED
<para>
Here's
</para>

<programlisting language="ruby">
    excel = WIN32OLE.new("excel.application")
</programlisting>

<para>
This
</para>
END_OF_EXPECTED
    seed = <<EOF
<para>
Here's
</para>

<!-- code file="/Users/nealford/dev/ruby/writeright/test/test_docs/code/daily_logs.rb" lang="ruby" -->

<para>
This
</para>
EOF
#    assert_equal expected, @ch.process_lines_from(seed)
  end
  
  def test_process_lines_to_insert_simple_code_file_with_no_parts
    expected = IO.readlines("#{TEST_DOCS}/02_simple_code_file_no_parts_expected.xml").join
    seed = IO.readlines("#{TEST_DOCS}/02_simple_code_file_no_parts_seed.xml").join
    assert_equal expected, @ch.process_lines_from(seed)
  end
end
