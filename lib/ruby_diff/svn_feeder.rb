# A Feeder reads in files for RubyDiff's processor to
# run over.  FileFeeder reads them from the file system.
#
# Example Usage:
#  ruby_diff --file old_version.rb --file new_version.rb
#  ruby_diff --file old_dir/ --file new_dir
class SVNFeeder
  attr_accessor :files
  attr_accessor :path
  
  include Enumerable
  
  # Expects something in the form of PATH
  #   --file [PATH]
  def initialize(path)
    @path = path
    @file_pattern = "**/*.rb"

    @files = []
    svn("ls -R #{@path}").each_line do |file|
      file.chomp!
      @files << file if File.fnmatch(@file_pattern, file)
    end
  end
    
  def each
    @files.each do |file|
      cat_path = File.join(@path, file)
      yield(svn("cat #{cat_path}"), file)
    end
  end


  # issues a command to svn
  def svn command
    output = `svn #{command} 2>&1`.chomp
    unless $?.success?
      raise RuntimeError, output
    end
    output
  end
end
