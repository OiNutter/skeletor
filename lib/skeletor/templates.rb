require 'YAML'

module Skeletor
  
  module Templates
    
    class Skeleton
      
      def initialize(template)
        
        begin
          @template = Loader.loadTemplate(template)
          @directory_structure = @template["directory_structure"] || []
          @tasks = @template["tasks"] || {}
          @includes = @template["includes"] || {}
          @path = @template["path"]
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
    
    class Loader
      
      TEMPLATE_PATH = File.expand_path(File.join(File.dirname(__FILE__), "templates"))
      USER_TEMPLATE_PATH = File.expand_path('~/.skeletor/templates')
       
      def self.loadTemplate(template)
        
        puts 'Loading Template - ' + template
        
        if File.exists?(template) && !File.directory?(template)
          skeleton = YAML.load_file(template)
          path = File.dirname(template)
        elsif File.exists?(File.join(template,File.basename(template) + '.yml'))
          skeleton = YAML.load_file(File.join(template,File.basename(template) + '.yml'))
          path = template
        elsif File.exists?(File.join(USER_TEMPLATE_PATH,template,template+'.yml'))
          skeleton = YAML.load_file(File.join(USER_TEMPLATE_PATH,template,template+'.yml'))
          path = File.join(USER_TEMPLATE_PATH,template)
        elsif File.exists?(File.join(TEMPLATE_PATH,template,template+'.yml'))
          skeleton = YAML.load_file(File.join(TEMPLATE_PATH,template,template+'.yml'))
          path = File.join(TEMPLATE_PATH,template)
        else
          raise LoadError, 'Template File Could Not Be Found'
        end
        
        puts 'Template ' + File.basename(template) + '.yml loaded from ' + path
        
        skeleton['path'] = path
        
        return skeleton
        
      end
      
    end
    
  end
  
end
