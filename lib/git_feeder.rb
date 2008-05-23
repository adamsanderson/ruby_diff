GitFile = Struct.new :access, :type, :hash, :name
class GitFeeder
  attr_accessor :files
  attr_accessor :path
  
  include Enumerable
  
  # Expects something in the form of REV:PATH
  #   --git REV:[PATH]
  def initialize(path)
    @path = path
    
    rev,path = path.split(":",2)
    raise ArgumentError.new("Must supply a git revision") unless rev
    path = File.expand_path(path) if path
    init_git(path || '.')
    @file_pattern = (@search_path == '') ? "**.rb" : File.join(@search_path,"**.rb")
    @files = []
          
    FileUtils.cd(@working_dir) do
      git_list = `git-ls-tree -r #{rev}`
      git_list.each_line do |line|
        file = GitFile.new(*line.chomp.split(/\s+/,4))
        
        if file.type == 'blob' and File.fnmatch(@file_pattern, file.name)
          @files << file        
        end
      end
    end
    
  end
    
  def each
    FileUtils.cd(@working_dir) do
      @files.each do |file|
        yield(`git-show #{file.hash}`)      
      end
    end
  end
    
  def init_git(path, search_path='')
    if File.exist?(File.join(path, ".git"))
      # If this is the git repository
      @working_dir = path
      @search_path = search_path
      
    else
      next_search = File.join( File.split(path).last, search_path )
      next_path = File.dirname(path)
      
      if next_path == path # We have reached the root, and can go no further
        raise "Could not find a git working directory"
      else
        init_git(next_path, next_search)
      end
    end
  end
  
end
