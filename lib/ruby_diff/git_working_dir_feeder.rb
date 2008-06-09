class GitWorkingDirFeeder
  attr_accessor :files
  attr_accessor :path
  
  include Enumerable
  include GitSupport
  
  # Expects something in the form of PATH
  #   --file [PATH]
  def initialize(path)
    @path = path
    
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
      git_list = git "ls-files"
      git_list.each_line do |line|
        file = line.chomp
        if File.fnmatch(@file_pattern, file)
          @files << file        
        end
      end
    end
    
  end
    
  def each
    FileUtils.cd(@working_dir) do
      @files.each do |file|
        yield(open(file, 'r'){|io| io.read}, file)      
      end
    end
  end

end
