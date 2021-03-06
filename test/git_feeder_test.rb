require 'test/unit'
require 'test/unit/testcase'
require "ruby_diff"

class GitFeederTestCase < Test::Unit::TestCase  
  GIT_REPO = File.join(File.dirname(__FILE__), "git_sample")
  
  def test_find_all_files
    assert File.exist?(GIT_REPO)
    feeder = GitFeeder.new "HEAD:#{GIT_REPO}"
    assert_equal 2, feeder.files.length
  end
  
  def test_find_single_file
    assert File.exist?(GIT_REPO)
    feeder = GitFeeder.new(File.join("HEAD:#{GIT_REPO}",'lib','chapter.rb'))
    assert_equal 1, feeder.files.length
  end
  
  def test_find_files_in_sub_dir
    feeder = GitFeeder.new(File.join("HEAD:#{GIT_REPO}",'lib'))
    assert_equal 1, feeder.files.length
  end
  
  def test_files_are_suitable_for_processing
    feeder = GitFeeder.new "HEAD:#{GIT_REPO}"
    assert_nothing_raised do
      sexps = feeder.map{|code,name| ParseTree.new.parse_tree_for_string(code)}

      sexps.each do |sexp|
        assert sexp.length > 0, "Parsed code should not be empty"
      end
    end
  end
  
  def test_revsision_required
    assert_raise RuntimeError do
      GitFeeder.new "hello"
    end
  end
  
  
end
