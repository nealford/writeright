require File.dirname(__FILE__) + "/language"

class FilterParts

  COMMENT_MARKERS = { :ruby => '#', :java => "//", :xml => "<!--" } 

  def initialize(language)
    @language = eval "$#{language}"
  end

  def part_marker
    Regexp.new("(.*)#{@language.comment_marker}\\s*(BEGIN|END)\\s*:")
  end

  def filter input
    m = part_marker.match(input)
    m ? m[1] : input
  end
  
end
