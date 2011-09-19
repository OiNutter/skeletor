require 'YAML'

module Skeletor
  
  module Templates
    
    class Skeleton
      
      def initialize(template)
        
        begin
          @template = Loader.loadTemplate(template)
          @directory_structure = @template["directory_structure"] || {}
          @tasks = @template["tasks"] || {}
          @includes = @template["includes"] || {}
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
      
    end
    
    class Loader
      
      TEMPLATE_PATH = File.expand_path(File.join(File.dirname(__FILE__), "templates"))
      USER_TEMPLATE_PATH = File.expand_path('~/.skeletor/templates')
       
      def self.loadTemplate(template)
        
        if File.exists?(template) && !File.is_directory?(template)
          skeleton = YAML.load_file(template)
        elsif File.exists?(File.join(template,template + '.yml'))
          skeleton = YAML.load_file(File.join(template,template + '.yml'))
        elsif File.exists?(File.join(USER_TEMPLATE_PATH,template,template+'.yml'))
          skeleton = YAML.load_file(File.join(USER_TEMPLATE_PATH,template,template+'.yml'))
        elsif File.exists?(File.join(TEMPLATE_PATH,template,template+'.yml'))
          skeleton = YAML.load_file(File.join(TEMPLATE_PATH,template,template+'.yml'))
        else
          raise LoadError, 'Template File Could Not Be Found'
        end
        
      end
      
    end
    
  end
  
end
