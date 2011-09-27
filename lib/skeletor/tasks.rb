module Skeletor
  
  # The *Tasks* class contains the included tasks that may
  # be run after the skeleton has been created.
  class Tasks
    
    # Initializes an empty git repository in the new project directory
    def self.git_init(path)
      system "cd " + path + '
              git init'
    end
    
    # Creates default capistrano deployment files in the new project directory
    def self.capify(path)
      system "capify " + path
    end
    
  end
  
end