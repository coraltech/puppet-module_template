
class Module_templateTemplate
  
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
  
  #---
  
  def self.filter(value)
    if ! value.is_a?(String)
      return 'false' if value == false
      return 'true'  if value == true
      return ''
    end
    return value
  end  
end