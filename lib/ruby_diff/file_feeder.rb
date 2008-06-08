class FileFeeder
  attr_accessor :files
  attr_accessor :path
  
  include Enumerable
  
  # Expects something in the form of PATH
  #   --file [PATH]
  def initialize(path)
    @path = path
    
    if path =~ /^\s+$/
      @file_pattern = "**/*.rb"
    elsif File.file? path
      @file_pattern = path
    else
      @file_pattern = File.join(path, "**/*.rb")
    end
    @files = Dir[@file_pattern]
  end
    
  def each
    @files.each do |file|
      yield(open(file, 'r'){|io| io.read}, file)      
    end
  end

end
