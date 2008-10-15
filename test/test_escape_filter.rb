require 'test/unit'
require  File.dirname(__FILE__) + "/.." + "/src/filter_escapes"

class TestEscapeFilter < Test::Unit::TestCase
  def test_escape_filtering
    {"for (int i = 0; i < 12; i++)" => "for (int i = 0; i &lt; 12; i++)",
      "<html><head><title>foo</title></head><body>bar</body></html>" => 
      "&lt;html&gt;&lt;head&gt;&lt;title&gt;foo&lt;/title&gt;&lt;/head&gt;&lt;body&gt;bar&lt;/body&gt;&lt;/html&gt;"}.each do |k, v|

      assert_equal v, FilterEscapes.filter(k)
    end
  end
end

