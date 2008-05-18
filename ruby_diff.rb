#!/usr/bin/env ruby 

require 'rubygems'
require 'parse_tree'
require 'sexp_processor'
require 'unified_ruby'
require 'set'
require 'pp'
require 'lib/structure_processor'
require 'lib/code_comparison'

class Unifier < SexpProcessor
  include UnifiedRuby
end

# git show HEAD~1:lib/code_comparison.rb

if __FILE__ == $0 then
  require 'optparse' 
  
  @options = {
    :mode=>:file
  }
  
  opts = OptionParser.new 
  opts.on('-v', '--version')    { puts "ruby_diff v:0" ; exit 0 }
  opts.on('-h', '--help')       { puts "Help is on the way" }
  
  opts.on('--sexp')             { @options[:sexp] = true }
  
  opts.on('--git')              { @options[:mode] = :git }
  opts.on('--file')             { @options[:mode] = :file }
  
  # TO DO - add additional options
  opts.parse!(ARGV)
  
  if @options[:mode] == :git
    rev1 = ARGV.shift
    rev2 = ARGV.shift
    path = ARGV.shift
    
    # "git show HEAD~1:lib/code_comparison.rb"
    source1 = `git show #{rev1}:#{path}`
    source2 = `git show #{rev2}:#{path}`
  else 
    file1 = ARGV.shift
    file2 = ARGV.shift
    source1 = open(file1, 'r').read()
    source2 = open(file2, 'r').read()
  end 
  
  sexp1 = ParseTree.new.parse_tree_for_string(source1, file1)
  sexp2 = ParseTree.new.parse_tree_for_string(source2, file2)
  
  if @options[:sexp]
    puts "---Old---"
    pp sexp1
    puts "---New---"
    pp sexp2
  end
  
  old_processor = StructureProcessor.new
  old_processor.process(*sexp1)
  new_processor = StructureProcessor.new
  new_processor.process(*sexp2)
  
  changes = old_processor.diff(new_processor).sort_by{|c| c.signature}
  changes.each do |change|
    puts change.to_s
  end
end