class FilterParts
  COMMENT_MARKERS = { :ruby => '#', :java => "//", :xml => "<!--" } 

  def initialize(language)
    @comment_marker = COMMENT_MARKERS[language.to_sym]
  end

  def part_marker
    Regexp.new("(.*)#{@comment_marker}\\s*(BEGIN|END)\\s*:")
  end

  def filter input
    m = part_marker.match(input)
    unless m
      input
    else
      m[1]
    end
  end
  
end
