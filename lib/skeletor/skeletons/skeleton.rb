module Skeletor
  
  module Skeletons
    
    class Skeleton
      
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
      
      def directory_structure
        @directory_structure
      end
      
      def tasks
        @tasks
      end
      
      def includes
        @includes
      end
      
      def path
        @path
      end   
      
    end
    
  end
  
end