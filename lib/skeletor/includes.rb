require 'fileutils'

module Skeletor
  
  class Includes
    
    def self.copy_include(include,target,path)
      
      #copy include to new path
      FileUtils.cp File.join(path,include), target
      
    end
    
  end
  
end