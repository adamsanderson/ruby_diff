# Common feeder support for working with git repositories.
module GitSupport

  # Finds root of a git repository.  If the repository is the parent of the
  # supplied path, then the remainder is made into the search path.
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
  
  # issues a command to git
  def git command
    output = `git #{command} 2>&1`.chomp
    unless $?.success?
      raise RuntimeError, output
    end
    output
  end
end
