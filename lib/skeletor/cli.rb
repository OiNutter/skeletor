require 'thor'

module Skeletor
  
  class CLI < Thor
    
    desc "build TEMPLATE [options]", "Build project skeleton from TEMPLATE"
    method_option :directory,             
                  :aliases => "-d",
                  :desc => "Sets the target directory. Defaults to current directory."
    method_option :project, 
                  :aliases => "-p",
                  :desc => "Sets the project name. Defaults to current directory name."
    def build(template)
      path = options[:directory] || Dir.pwd
      project = options[:project] || File.basename(path)
      
      skeleton = Builder.new(project,template,path)
      skeleton.build
    end

    desc "clean [options]" ,"Clean directory"
    method_option :directory,
                  :aliases => "-d",
                  :desc => "Sets the target directory. Defaults to current directory"
    def clean
      path = options[:directory] || Dir.pwd   
      Builder.clean path
    end
    
    desc "validate TEMPLATE" ,"Checks TEMPLATE is a valid YAML file and matches the required schema."    
    def validate(template)
      skeleton = Skeletons::Loader.loadTemplate(template)
      validator = Skeletons::Validator.new(skeleton)
      validator.validate()
    end
    
  end
  
end