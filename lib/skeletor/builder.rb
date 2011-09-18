module Skeletor
  
  class Builder
    
    def initialize(project,template,path)
      
      @project = project
      @template = Templates::Skeleton.new(template)
      @path = path
      
    end
    
    def build()
      
      #build directory structure
      build_directories(@template.directory_structure)
      
    end
    
    def build_directories(dirs,path=@path)
      
      dirs.each_pair{
        
        |dir,content|
        
        Dir.mkdir(File.join(path,dir))
        
        if content.kind_of?(Hash) && !content.empty?()
          
          build_directories(content,File.join(path,dir))
          
        end
        
      }
      
    end
    
    def clean_directory(path)
      
      
      
    end
    
  end
  
end