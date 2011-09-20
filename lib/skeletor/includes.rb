require 'fileutils'
require 'uri'

autoload :HTTP, 'skeletor/protocols/http'
autoload :HTTPS, 'skeletor/protocols/https'

module Skeletor
  
  class Includes
    
    PROTOCOL_PATTERN = /^\w+(?=:\/\/)/
    SUPPORTED_PROTOCOLS = ['http','https']
    
    def self.copy_include(include,target,path)
      
      #if include path includes a protocol. Load from that
      protocol = PROTOCOL_PATTERN.match(include).to_s().downcase 
      if protocol != nil
        if SUPPORTED_PROTOCOLS.find_index(protocol) != nil
          case protocol
          when 'http'
              content = HTTP.get URI.parse(include)
            when 'https'
              uri = URI.parse(include)
              http = HTTPS.new uri.host,443
              http.use_ssl = true
              req = HTTPS::Get.new uri.path
              request = http.request(req)
              content = request.body
            else
              raise TypeError, 'Unsupported protocol for remote file. Only the following are supported: ' + SUPPORTED_PROTOCOLS.join(', ') 
           end
        end
      else
        content = File.open File.join(path,include)
      end
      
      File.open(target,'w'){|f| f.write(content)}
      
    end
    
  end
  
end