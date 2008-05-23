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

class Unifier < SexpProcessor
  include UnifiedRuby
end

# git show HEAD~1:lib/code_comparison.rb

if __FILE__ == $0 then
  require 'optparse' 
  
  @options = {
    :mode=>:file
  }
  
  feeder_mapping = {
    :file =>  FileFeeder,
    :git  =>  GitFeeder
  }
  
  feeders = []
  
  opts = OptionParser.new   
  opts.banner = "Usage: ruby_diff.rb [options]"
  
  opts.separator ""
  opts.separator "Specific options:"
  
  opts.define_head <<-HEAD
  
Examples:
Changes between git HEAD and current file system:
  ruby_diff.rb --git HEAD --file ./

Changes between HEAD and previous revision:
  ruby_diff.rb --git HEAD~1 --git HEAD
HEAD
  
  opts.on('--sexp', "Show the s expressions for each input"){ 
    @options[:sexp] = true 
  }
  
  opts.on('--git PATH', "Use a git repository as a code source"){|path| 
    feeders << feeder_mapping[:git].new(path) 
  }
  opts.on('--file PATH', "Use a file system path as a code source"){|path| 
    feeders << feeder_mapping[:file].new(path) 
  }
  
  opts.on_tail('-v', '--version')    { puts "ruby_diff v:0" ; exit }
  opts.on_tail('-h', '--help')       { puts opts; exit }
  
  opts.parse!(ARGV)
  
  # Map remaining options as file feeders
  ARGV.each do |path|
    feeders << feeder_mapping[:file].new(path)
  end
  
  if feeders.length > 2
    puts opts
    puts "Too many code sources (#{feeders.length})"
    exit 1
  elsif feeders.length < 2
    puts opts
    puts "Must supply least 2 code sources (#{feeders.length})"
    exit 1
  end
  
  processors = feeders.map do |feeder|
    puts "#{feeder.class}: #{feeder.path}" if @options[:sexp]
    processor = StructureProcessor.new
    feeder.each do |code|
      sexp = ParseTree.new.parse_tree_for_string(code)
      if @options[:sexp]
        pp sexp
        puts "--"
      end
      
      processor.process(*sexp)
    end
    
    processor
  end
  
   
  old_processor, new_processor = *processors
  
  changes = old_processor.diff(new_processor).sort_by{|c| c.signature}
  changes.each do |change|
    puts change.to_s
  end
end
