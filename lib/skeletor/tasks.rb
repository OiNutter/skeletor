module Skeletor
  
  class Tasks
    
    def self.git_init(path)
      system "cd " + path + '
              git init'
    end
    
    def self.capify(path)
      system "capify " + path
    end
    
  end
  
end