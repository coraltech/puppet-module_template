
module ModuleTemplate
  
  def self.filter(value)
    if ! value.is_a?(String)
      return 'false' if value == false
      return 'true'  if value == true
      return ''
    end
    return value
  end
  
module Environment
  #-----------------------------------------------------------------------------
  # Renderers  
   
  def self.render(input)
    output = ''    
    case input.class      
    when Hash
      input.each do |name, value|
        if value.is_a?(Array)
          values = []
          value.each do |item|
            item = filter(item)
            values << "'#{item}'"  
          end
          output << "export #{name}=(#{values.join(' ')})\n"
          
        elsif value.is_a?(String)
          value = filter(value)
          output << "export #{name}='#{value}'\n"
        end
      end
    end              
    return output      
  end
end

#*******************************************************************************
#*******************************************************************************
  
module Config
  #-----------------------------------------------------------------------------
  # Renderers  
   
  def self.render(input)
    output = ''    
    case input.class      
    when Hash
      input.each do |name, value|
        if value.is_a?(Array)
          value.each do |item|
            item = filter(item)
            output << "#{name} #{item}\n"  
          end
          
        elsif value.is_a?(String)
          value = filter(value)
          output << "#{name} #{value}\n"
        end
      end
    end              
    return output      
  end
end
end