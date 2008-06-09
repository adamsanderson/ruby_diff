require 'rubygems'

# ParseTree
require 'parse_tree'
require 'sexp_processor'
require 'unified_ruby'
require 'fileutils'

# Standard library
require 'set'
require 'pp'

module RubyDiff
  VERSION = "0.1.1"
end

# RubyDiff
%w(code_comparison structure_processor file_feeder git_support git_feeder git_working_dir_feeder).each do |name|
  require File.expand_path(File.dirname(__FILE__) + "/ruby_diff/#{name}")
end
