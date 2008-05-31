#!/usr/bin/env ruby 

require 'rubygems'

# ParseTree
require 'parse_tree'
require 'sexp_processor'
require 'unified_ruby'
require 'fileutils'

# Standard library
require 'set'
require 'pp'

# RubyDiff
%w(code_comparison structure_processor file_feeder git_feeder).each do |name|
  require File.expand_path(File.dirname(__FILE__) + "/lib/#{name}")
end