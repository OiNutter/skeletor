require 'thor'

module Skeletor
  
  # The *CLI* class provides an interface for the command line functions 
  class CLI < Thor
    
    
    desc "build TEMPLATE [options]", "Build project skeleton from TEMPLATE"
    method_option :directory,             
                  :aliases => "-d",
                  :desc => "Sets the target directory. Defaults to current directory."
    method_option :project, 
                  :aliases => "-p",
                  :desc => "Sets the project name. Defaults to current directory name."
    # Creates a new *Builder* instance and builds the skeleton in the specified directory
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
    # Cleans out the specified directory
    def clean
      print 'Are you sure you want to clean this project directory? (Y|n): '
      confirm = $stdin.gets.chomp
      if confirm != 'Y' && confirm != 'n'
        puts 'Please enter Y or n'
      elsif confirm == 'Y'
        path = options[:directory] || Dir.pwd
        Builder.clean path
      end
      
    end
    
    desc "validate TEMPLATE" ,"Checks TEMPLATE is a valid YAML file and matches the required schema."
    # Loads a template, creates a new *Validator* and validates the template    
    def validate(template)
      skeleton = Skeletons::Loader.loadTemplate(template)
      validator = Skeletons::Validator.new(skeleton)
      validator.validate()
    end
    
  end
  
end