# Lifted from hpricot, because I figure _why has it figured out
NAME = "ruby_diff"
VERS = "0.1"
PKG_FILES = %w(README Rakefile) +
      Dir.glob("{bin,doc,test,lib,extras}/**/*")

SPEC = Gem::Specification.new do |s|
    s.name = NAME
    s.version = VERS
    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]
    s.summary = "a higher level diff application for analyzing changes to ruby code"
    s.description = s.summary
    s.author = "Adam Sanderson"
    s.email = 'netghost@gmail.com'
    s.homepage = 'http://endofline.wordpress.com'
    s.files = PKG_FILES
    s.executables << 'ruby_diff'
    s.add_dependency 'ParseTree'
  end
