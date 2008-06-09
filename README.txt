= RubyDiff

RubyDiff does higher level comparisons of ruby code.

When looking at large sets of changes between versions of files, it is 
important to get an idea of what classes, modules, and methods change.
RubyDiff aims to reveal substantive changes to code, and let you ignore
trivial changes like whitespace being added to a document.

Code and Releases:
  http://rubyforge.org/projects/rubydiff
  
Browse or Branch:
  http://github.com/adamsanderson/ruby_diff/tree/master

RDoc for internals (a bit sparse at the moment)
  http://rubydiff.rubyforge.org/

== Requirements
RubyDiff depends on ParseTree, the easiest way to get it is via ruby gems:
  gem install ParseTree
  
== Caveats
This is just the beginnings of an experiment, so all that is captured are
changes to instance methods.  The API is likely to change drastically.

== Usage
This is likely to change a bunch, but for the moment:
  ruby_diff old_file new_file
  
Or for git repositories, etc.
  ruby_diff --git HEAD --file ./
  
Compare three different release tags.
  ruby_diff --git v0.1 --git v0.2 --git v0.3
  
See help for more information.

== Contact
Feel free to get in touch with me:
  netghost@gmail.com
