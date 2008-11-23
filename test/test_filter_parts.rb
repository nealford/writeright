require 'test/unit'
require  File.dirname(__FILE__) + "/.." + "/lib/filter_parts"

class TestFilterParts < Test::Unit::TestCase

  def test_correct_filter_regex_based_on_language
    fp = FilterParts.new(:ruby)
    assert_equal /(.*)#\s*(BEGIN|END)\s*:/, fp.part_marker
  end
  
  def test_parts_for_ruby
    filter = FilterParts.new(:ruby)
    ["some code # BEGIN: foo",
     "some code # END: foo",
     "some code       # BEGIN: bar",
     "some code  #BEGIN: foobar"].each do |part|
      assert_equal "some code", filter.filter(part).strip
    end
  end

  def test_parts_for_java
    filter = FilterParts.new(:java)
    ["overly verbose code // BEGIN: foo",
     "overly verbose code //BEGIN:foo",
     "overly verbose code //     END: bar",
     "overly verbose code        //         BEGIN :     foobar"].each do |part|
      assert_equal "overly verbose code", filter.filter(part).strip
    end
  end

  def test_parts_for_xml
    filter = FilterParts.new(:xml)
    ["some xml <!-- BEGIN: foo -->",
     "some xml <!--BEGIN:foo-->",
     "some xml <!--     END      : bar -->"].each do |part|
      assert_equal "some xml", filter.filter(part).strip
    end
  end
  
end
