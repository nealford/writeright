class CodeFomatter
  def initialize(metadata_about_code)
    @code = metadata_about_code
  end

  def get_formatter
    case @code.lang of
    when "java" : SimpleCodeFormatter.new("//")
    end
    
  end
  
  
end
