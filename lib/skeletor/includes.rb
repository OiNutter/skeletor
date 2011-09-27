require 'uri'

autoload :HTTP, 'skeletor/protocols/http'
autoload :HTTPS, 'skeletor/protocols/https'

module Skeletor
  
  # The *Includes* class contains methods for dealing with
  # loading and parsing required include files.
  class Includes
    
    # Internal regular expression to match for includes that should be loaded from a remote destination
    PROTOCOL_PATTERN = /(?:([a-z][\w-]+):(?:\/{1,3}|[a-z0-9%]))/
    # Specifies a list of supported protocols that *Skeletor* can load from.
    SUPPORTED_PROTOCOLS = ['http','https']
    
    # Reads the required include from either the remote url or the local path and writes it to the 
    # required location in the skeleton.
    def self.copy_include(include,target,path)
      
      #if include path includes a protocol. Load from that
      matches = PROTOCOL_PATTERN.match(include).to_a
      if !matches.empty?
        protocol = matches[1].to_s.downcase
        if !SUPPORTED_PROTOCOLS.find_index(protocol).nil?
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
              raise TypeError, 'Unsupported protocol ' + protocol + ' for remote file. Only the following are supported: ' + SUPPORTED_PROTOCOLS.join(', ') 
           end
           puts 'Copying remote file ' + include + ' to ' + target
        else
          raise TypeError, 'Unsupported protocol for remote file. Only the following are supported: ' + SUPPORTED_PROTOCOLS.join(', ') 
        end
      else
        puts 'Copying ' + include +  ' from template directory to ' + target
        file = File.open(File.join(path,include))
        content = file.gets 
      end
      
      File.open(target,'w'){|f| f.write(content)}
      
    end
    
  end
  
end