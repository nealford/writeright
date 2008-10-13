require "test/unit"

require File.dirname(__FILE__) + "/.." + "/src/code_harvest"
require 'rubygems'


class TestCodeHarvest < Test::Unit::TestCase
  TEST_DOCS = "./test_docs" 

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

  def test_escape_filtering
    {"for (int i = 0; i < 12; i++)" => "for (int i = 0; i &lt; 12; i++)",
      "<html><head><title>foo</title></head><body>bar</body></html>" => 
      "&lt;html&gt;&lt;head&gt;&lt;title&gt;foo&lt;/title&gt;&lt;/head&gt;&lt;body&gt;bar&lt;/body&gt;&lt;/html&gt;"}.each do |k, v|
      assert_equal v, @ch.send(:filter_escapes, k)
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
    expected = <<EOF
<para>
Here's an example that I use all the time.
</para>

<programlisting language="ruby"><![CDATA[class DailyLogs
    private 
    @@Home_Dir = "c:/MyDocuments/Documents/"
    
  def doc_list
    docs = Array.new
    docs << "Sisyphus Project Planner.xls"
    docs << "TimeLog.xls"
    docs << "NFR.xls"
  end

  def open_daily_logs
    excel = WIN32OLE.new("excel.application")
        
    workbooks = excel.WorkBooks
    excel.Visible = true
    doc_list.each do |f| 
      begin
        workbooks.Open(@@Home_Dir + f, true)
      rescue
        puts "Cannot open workbook:", @@Home_Dir + f
      end
    end
    excel.Windows.Arrange(7)
  end
end

]]></programlisting>

<para>
This rake file lists all the files that I need to open and all the applications required for the talk.
</para>
EOF
    seed = <<EOF
<para>
Here's an example that I use all the time.
</para>

<!-- code file="/Users/nealford/dev/ruby/writeright/test/test_docs/code/daily_logs.rb" lang="ruby" -->

<para>
This rake file lists all the files that I need to open and all the applications required for the talk.
</para>
EOF
    assert_equal expected, @ch.process_lines_from(seed)
  end
end
