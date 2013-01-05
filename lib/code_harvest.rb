=begin rdoc
Todo:
  Decorators for build_output_based_on metadata
X remove part markers from code
  harvest parts
  callouts!
=end

require File.dirname(__FILE__) +  "/code_metadata"

class CodeHarvest
  REGEX_IS_CODE = /code\s+file\s*=.*/
  REGEX_PARTS = /.*part\s*=.*/
  CODE_POSTLUDE = "</programlisting>\n"
  ESCAPES = { '<' => '&lt;', '>' => '&gt;', '&' => '&amp;'}

  def is_code? line
    polished(line) =~ REGEX_IS_CODE
  end

  def process_lines_from list_with_lines
    list_with_lines.collect { |line| build_output_based_on(line) }.join
  end
private

  def code_prelude_for(language)
    "<programlisting language=\"#{language}\">"
  end

  def polished line
    line.clone.sub("<!--", '').sub("-->", '')
  end

  def build_output_based_on line
    return line unless is_code? line
    metadata = CodeMetadata.new(line)
    output = []
    output << code_prelude_for(metadata.lang) + "<![CDATA[\n"
    found_part = false
    IO.readlines(metadata.file_name).each do |source_line|
      if (metadata.has_parts?)
        if (source_line =~ /.*#.?end:.*#{metadata.part}.*/)
          found_part = false
        end
        if found_part
          output << filter_escapes(source_line) + "\n"
        end
        if (source_line =~ /.*#.?begin:.?#{metadata.part}.*/)
          found_part = true
        end
      else
        output << filter_escapes(source_line) + "\n"
      end
    end
    output << "]]>"
    output << CODE_POSTLUDE
    output.join
  end
  
  def filter_escapes source_line
    out = ""
    source_line.scan(/./) { |c| out << (ESCAPES.has_key?(c) ? ESCAPES[c] : c) }
    out
  end
  
end
