class FilterEscapes
  ESCAPES = { '<' => '&lt;', '>' => '&gt;', '&' => '&amp;'}

  def self.filter input
    line_with_escaped_characters = ""
    input.scan(/./) { |c| line_with_escaped_characters << (ESCAPES.has_key?(c) ? ESCAPES[c] : c) }
    line_with_escaped_characters
  end
end
