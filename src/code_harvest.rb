=begin rdoc
Todo:
  Decorators for build_output_based_on metadata
  remove part markers from code
  harvest parts
  callouts!
=end

require File.dirname(__FILE__) +  "/code_metadata"

class CodeHarvest
  REGEX_IS_CODE = /\s*<!--\s*code\s+file\s*=.*/
  REGEX_PARTS = /.*part\s*=.*/
  CODE_POSTLUDE = "</programlisting>\n"

  def is_code_line? line
    line =~ REGEX_IS_CODE
  end

  def process_lines_from list_with_lines
    output = []
    list_with_lines.each_line do |l|
      unless is_code_line? l
        output << l
      else
        output << build_output_based_on(CodeMetadata.new(l))
      end
    end
    output.join
  end

private

  def code_prelude_for(language)
    "<programlisting language=\"#{language}\">"
  end

  def build_output_based_on metadata 
    output = []
    output << code_prelude_for(metadata.lang) + (metadata.has_parts? ? "" : "<![CDATA[")
    IO.readlines(metadata.file_name).each do |source_line|
      output << (metadata.has_parts? ? filter_escapes(source_line) + "\n" : source_line)
    end
    output << "]]>" unless metadata.has_parts?
    output << CODE_POSTLUDE
    output.join
  end
  
end
