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
    @file_pattern = if @search_path == ''
      "**.rb"
    elsif @search_path =~ /\.rb#{File::SEPARATOR}$/
      # So appending each piece into the search path during init_git
      # causes the search path to always end with a /
      @search_path[0...-1]
    else
      File.join(@search_path,"**.rb")
    end
    
    @files = []
          
    FileUtils.cd(@working_dir) do
      git_list = git "ls-tree -r #{rev}"
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
        code = git "show #{file.hash}"
        yield(code)      
      end
    end
  end
    
  def init_git(path, search_path='')
    path = File.expand_path(path)
    if File.exist?(File.join(path, ".git"))
      # If this is the git repository
      @working_dir = path
      @search_path = search_path
      
    else
      next_search = File.join( File.basename(path), search_path )
      next_path = File.dirname(path)
      
      if next_path == path # We have reached the root, and can go no further
        raise "Could not find a git working directory"
      else
        init_git(next_path, next_search)
      end
    end
  end
  
  def git command
    output = `git #{command} 2>&1`.chomp
    unless $?.success?
      raise RuntimeError, output
    end
    output
  end
  
end
