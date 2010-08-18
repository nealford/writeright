module TestDirectives

  def produce_output_for_diffing
    @produce_xml_output_for_diffing = ENV['XML_OUTPUT'] == 'YES'
  end

  def method_added(method_name)
  end
  
end
