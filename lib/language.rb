Language = Struct.new(:name, :extension, :comment_marker)

$ruby = Language.new("ruby", "rb", "#")
$java = Language.new("java", "java", "//")
$xml = Language.new("xml", "xml", "<!--");
