require 'yaml'
require 'hike'
require 'grayskull'

module Skeletor
  
  module Skeletons
    # *Loader* is a wrapper class to handle loading in the template file 
    # from the various possible load paths.
    #
    # While accessible externally this is generally called internally.
    class Loader
      
      # *TEMPLATE_PATH* specifies the internal directory for any included project templates.
      TEMPLATE_PATH = File.expand_path(File.join(File.dirname(File.dirname(__FILE__)), "templates"))
      # *USER_TEMPLATE_PATH* specifies the path to the users personal template directory
      USER_TEMPLATE_PATH = File.expand_path('~/.skeletor/templates')
      
      # Searches for the specified template and loads it into a variable
      #
      # Also adds the path where it was found to the returned Hash
      def self.load_template(template)
        
        puts 'Loading Template - ' + template
        
        #if File.exists?(template) && !File.directory?(template)
        #  skeleton = YAML.load_file(template)
        #  path = File.dirname(template)
        #elsif File.exists?(File.join(template,File.basename(template) + '.yml'))
        #  skeleton = YAML.load_file(File.join(template,File.basename(template) + '.yml'))
        #  path = template
        #elsif File.exists?(File.join(USER_TEMPLATE_PATH,template,template+'.yml'))
        #  skeleton = YAML.load_file(File.join(USER_TEMPLATE_PATH,template,template+'.yml'))
        #  path = File.join(USER_TEMPLATE_PATH,template)
        #elsif File.exists?(File.join(TEMPLATE_PATH,template,template+'.yml'))
        #  skeleton = YAML.load_file(File.join(TEMPLATE_PATH,template,template+'.yml'))
        #  path = File.join(TEMPLATE_PATH,template)
        #else
        #  raise LoadError, 'Error: Template File ' + File.basename(template) + ' Could Not Be Found'
        #end
        
        if File.exists?(template) && !File.directory?(template)
          result = template
        else
          trail = Hike::Trail.new "/"
          trail.append_extensions ".yml", ".json" 
          
          if File.directory?(template)
            trail.append_paths template
            result = trail.find File.basename(template)
          else
            trail.append_paths USER_TEMPLATE_PATH, TEMPLATE_PATH
            result = trail.find File.basename(template) + "/" + File.basename(template)
          end
                
        end
        
        if result
          begin
            file = File.basename(result)
            path = File.dirname(result)
            skeleton = Grayskull::DataFile.load(result)
            skeleton['file'] = file
            skeleton['path'] = path
            puts 'Template ' + file + ' loaded from ' + path
         rescue Exception => e
          puts e.message
          exit
         end
        end
        
        puts 'Template ' + file + ' loaded from ' + path
                
        return skeleton
        
      end
      
    end
    
  end
  
end