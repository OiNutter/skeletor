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

    desc "clean [options]" ,"clean directory"
    method_option :directory,
                  :aliases => "-d",
                  :desc => "Sets the target directory. Defaults to current directory"
    def clean
      path = options[:directory] || Dir.pwd   
      Builder.clean path
    end
    
  end
  
end