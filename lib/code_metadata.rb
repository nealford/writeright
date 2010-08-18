class CodeMetadata
  attr_reader :file_name, :lang, :part
  REGEX_CODE = /\s*code\s+file\s*=\s*"((?:\w|[.\/])+)"\s+lang\s*=\s*"(\w+)"\s*(?:part\s*=\s*"(\w+)")?/

  def initialize(line)
    unless (line.clone.sub("<!--", '').sub("-->", '') =~ REGEX_CODE)
      raise Exception, "Looks like a code import but isn't: #{line}"
    end
    @file_name = $1
    @lang = $2
    @part = $3
  end

  def has_parts?
    @part
  end
end
