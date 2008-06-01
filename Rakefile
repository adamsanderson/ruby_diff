require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'rake/rdoctask'

task :default => "git:changed"

# Lifted from hpricot, because I figure _why has it figured out
NAME = "ruby_diff"
VERS = "0.1"
PKG_FILES = %w(README Rakefile) +
      Dir.glob("{bin,doc,test,lib,extras}/**/*")

SPEC =
  Gem::Specification.new do |s|
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



desc "Run tests"
Rake::TestTask.new("test") do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = false
  t.warning = true
end

desc "Shows what has changed since the last commit"
namespace :git do
  task :changed do |t|
    puts `./bin/ruby_diff --git HEAD --file ./`
  end
end

Rake::GemPackageTask.new(SPEC) do |pkg| end