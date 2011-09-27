module Skeletor
  
  module Skeletons
    
    # The *Skeleton* class provides a wrapper round the template file
    # and handles loading it and validating it, as well as providing 
    # default values for any missing sections.
    class Skeleton
      
      #Creates a new *Skeleton* instance from `template`
      def initialize(template)
        
        begin
          @template = Loader.loadTemplate(template)
          validator = Validator.new(@template)
          if validator.validate
            @directory_structure = @template["directory_structure"] || []
            @tasks = @template["tasks"] || {}
            @includes = @template["includes"] || {}
            @path = @template["path"]
          else
            exit
          end
        rescue LoadError => e
          puts e.message
          exit
        end
          
      end
      
      # Returns the directory structure section
      def directory_structure
        @directory_structure
      end
      
      # Returns the tasks section
      def tasks
        @tasks
      end
      
      # Returns the includes section
      def includes
        @includes
      end
      
      # Returns the template path
      def path
        @path
      end   
      
    end
    
  end
  
end