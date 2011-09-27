require 'fileutils'

module Skeletor
  
  # The *Builder* class performs the main task of parsing the 
  # loaded *Skeleton* and generating a project structure from it.
  class Builder
    
    # Creates a new *Builder* instance
    def initialize(project,template,path)
      
      @project = project
      @template_name = File.basename(template).gsub('.yml','')
      @template = Skeletons::Skeleton.new(template)
      @path = path
      
    end
    
    # Builds the project skeleton
    #
    # If the target directory does not exist it is created, then the 
    # directory structure is generated.
    #
    # Once the folder structure is set up and all includes have been 
    # loaded/created, any tasks specified in the template file are run.    
    def build()
      
      #check dir exists, if not, make it
      if(!File.exists?(@path))
        Dir.mkdir(@path)
      end
      
      #build directory structure
      puts 'Building directory structure'
      build_skeleton(@template.directory_structure)
      
      #execute build tasks
      puts 'Running build tasks'
      execute_tasks(@template.tasks,@template.path)
      
      puts 'Skeleton built'
      
    end
    
    # Builds the directory structure
    def build_skeleton(dirs,path=@path)
        
        dirs.each{
          |node|
          
          if node.kind_of?(Hash) && !node.empty?()
            node.each_pair{
              |dir,content| 
          
              puts 'Creating directory ' + File.join(path,dir)
              Dir.mkdir(File.join(path,dir))
        
              if content.kind_of?(Array) && !content.empty?()
                build_skeleton(content,File.join(path,dir))
              end
              
            }
          elsif node.kind_of?(Array) && !node.empty?()
            node.each{
              |file|
              
              write_file(file,path)
        
            }
          end
          
      }
      
    end
    
    # Cleans the directory of all files and folders
    def self.clean(path=@path)
      
      puts 'Cleaning directory of files and folders'
      start_dir = Dir.new(path)
      
      start_dir.each{
        |dir|
        
        if dir != '.' && dir != '..'
          FileUtils.rm_r File.join(path,dir), {:secure=>true}  
        end
        
      }
      puts 'Directory cleaned'
      
    end
    
    # Checks if file is listed in the includes list and if so copies it from
    # the given location. If not it creates a blank file.
    def write_file(file,path)
      
      #if a pre-existing file is specified in the includes list, copy that, if not write a blank file      
      if @template.includes.has_key?(file)
        begin
          Includes.copy_include(@template.includes[file],File.join(path,file),@template.path)
        rescue TypeError => e
          puts e.message
          exit
        end
      else
        puts 'Creating blank file: ' + File.join(path,file)
        File.open(File.join(path,file),'w')
      end
      
    end
    
    # Parses the task string and runs the task.
    #
    # Will check *Skeleton::Tasks* module first before running tasks
    # from the `tasks.rb` file in the template directory.
    def execute_tasks(tasks,template_path)
      
      if File.exists?(File.expand_path(File.join(template_path,'tasks.rb')))
        load File.expand_path(File.join(template_path,'tasks.rb'))
      end
       
      tasks.each{
        |task|
        
        puts 'Running Task: ' + task
        
        task = task.gsub('<skeleton_path>',@path)
        task = task.gsub('<skeleton_project>',@project)
        task = task.gsub('<skelton_template>',@template_name)
        
        options = task.split(', ')
        action = options.slice!(0)
        
        if(Tasks.respond_to?(action))
          Tasks.send action, options.join(', ')
        else
          send action, options.join(', ')
        end
        
      }
                  
    end
    
  end
  
end