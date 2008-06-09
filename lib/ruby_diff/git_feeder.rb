# A Feeder reads in files for RubyDiff's processor to
# run over.  GitFeeder reads them from a git repository.
#
# Example Usage:
#  ruby_diff --git v0.1:lib --git v0.1:lib
#  ruby_diff --git HEAD^2 --git HEAD^1 --git HEAD
class GitFeeder
  GitFile = Struct.new :access, :type, :hash, :name
  
  attr_accessor :files
  attr_accessor :path
  
  include Enumerable
  include GitSupport
  
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
        yield(code, file.name)      
      end
    end
  end
  
end
