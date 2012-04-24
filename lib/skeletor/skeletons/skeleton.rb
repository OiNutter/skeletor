require 'grayskull'

module Skeletor
  
  module Skeletons
    
    # The *Skeleton* class provides a wrapper round the template file
    # and handles loading it and validating it, as well as providing 
    # default values for any missing sections.
    class Skeleton
      
      # Defines the location to the required schema file for the templates
      SCHEMA_FILE = File.join Skeletons::Loader::TEMPLATE_PATH,'template-schema.yml'
      
      #Creates a new *Skeleton* instance from `template`
      def initialize(template)
        
        begin
          @template = Loader.load_template(template)
          validator = Grayskull::Validator.new(@template,SCHEMA_FILE)
          results = validator.validate
          if results["result"]
            puts "Validated Successfully!"
            @directory_structure = @template["directory_structure"] || []
            @tasks = @template["tasks"] || {}
            @includes = @template["includes"] || {}
            @path = @template["path"]
          else
            puts 'Validation Failed with ' + results["errors"].count.to_s + ' errors';
            puts ''
            results["errors"].each{
              |error|
              puts error            
            }
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
