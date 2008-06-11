# A Feeder reads in files for RubyDiff's processor to
# run over.  FileFeeder reads them from the file system.
#
# Example Usage:
#  ruby_diff --svn PREV:file.rb --svn new_version.rb
#  ruby_diff --svn http://project.server.org/lib --svn .
class SVNFeeder
  attr_accessor :files
  attr_accessor :path
  
  include Enumerable
  
  # Expects something in the form of PATH
  #   --file [PATH]
  def initialize(path)
    @path = path
    
    # TODO: Add support for SVN date format
    if @path =~ /^(\d+)|HEAD|BASE|COMMITTED|PREV\:/
      parts = path.split(":",2)
      svn_path = parts.pop
      rev = parts.shift
    else
      svn_path = @path
      rev = nil
    end
    
    @svn_options = (rev ? "-r #{rev} " : " ")+svn_path
    
    @file_pattern = "**/*.rb"

    @files = []
    
    svn("ls -R #{@svn_options}").each_line do |file|
      file.chomp!
      @files << file if File.fnmatch(@file_pattern, file)
    end
  end
    
  def each
    @files.each do |file|
      cat_path = File.join(@svn_options, file)
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
