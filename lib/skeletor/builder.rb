require 'fileutils'

module Skeletor
  
  class Builder
    
    def initialize(project,template,path)
      
      @project = project
      @template = Templates::Skeleton.new(template)
      @path = path
      
    end
    
    def build()
      
      #check dir exists, if not, make it
      if(!File.exists?(@path))
        Dir.mkdir(@path)
      end
      
      #build directory structure
      build_skeleton(@template.directory_structure)
      
    end
    
    def build_skeleton(dirs,path=@path)
        
        dirs.each{
          |node|
          
          if node.kind_of?(Hash) && !node.empty?()
            node.each_pair{
              |dir,content| 
          
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
    
    def self.clean(path=@path)
      
      start_dir = Dir.new(path)
      
      start_dir.each{
        |dir|
        
        if dir != '.' && dir != '..'
          FileUtils.rm_r File.join(path,dir), {:secure=>true}  
        end
        
      }
      
    end
    
    def write_file(file,path)
      
      #if a pre-existing file is specified in the includes list, copy that, if not write a blank file      
      if @template.includes.has_key?(file)
        Includes.copy_include(@template.includes[file],File.join(path,file),@template.path)
      else
        File.open(File.join(path,file),'w')
      end
      
    end
    
  end
  
end