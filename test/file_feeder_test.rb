require 'test/unit'
require 'test/unit/testcase'
require "ruby_diff"

DIR = File.join(File.dirname(__FILE__), "git_sample")

class FileFeederTestCase < Test::Unit::TestCase  
  
  def test_find_all_files
    assert File.exist?(DIR)
    feeder = FileFeeder.new DIR
    assert_equal 2, feeder.files.length
  end
  
  def test_find_single_file
    assert File.exist?(DIR)
    feeder = FileFeeder.new(File.join(DIR,'lib','chapter.rb'))
    assert_equal 1, feeder.files.length
  end
  
  def test_find_files_in_sub_dir
    feeder = FileFeeder.new(File.join(DIR,'lib'))
    assert_equal 1, feeder.files.length
  end
  
  def test_files_are_suitable_for_processing
    feeder = FileFeeder.new DIR
    assert_nothing_raised do
      sexps = feeder.map{|code| ParseTree.new.parse_tree_for_string(code)}

      sexps.each do |sexp|
        assert sexp.length > 0, "Parsed code should not be empty"
      end
    end
  end
  
end
