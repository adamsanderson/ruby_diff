require 'rubygems'
require 'parse_tree'
require 'sexp_processor'
require 'unified_ruby'
require 'set'
require 'lib/structure_processor'
require 'lib/code_comparison'

class Unifier < SexpProcessor
  include UnifiedRuby
end

if __FILE__ == $0 then
  file1 = ARGV.shift
  file2 = ARGV.shift
  
  source1 = open(file1, 'r').read()
  source2 = open(file2, 'r').read()
  
  sexp1 = ParseTree.new.parse_tree_for_string(source1, file1)
  sexp2 = ParseTree.new.parse_tree_for_string(source2, file2)
  
  # TODO: this returns the sexp, NOT what we want
  old_processor = StructureProcessor.new
  old_processor.process(*sexp1)
  new_processor = StructureProcessor.new
  new_processor.process(*sexp2)
  
  changes = old_processor.diff(new_processor).sort_by{|c| c.signature}
  changes.each do |change|
    puts "#{change.signature} #{change.operation}"
  end
end