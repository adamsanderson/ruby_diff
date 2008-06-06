require 'test/unit'
require 'test/unit/testcase'
require "ruby_diff"

class CodeComparisonTestCase < Test::Unit::TestCase  
  def setup
    @old_objects = []
    @new_objects = []
    @changes = nil
  end
  
  def test_empty_set
    assert_changes
  end
  
  def test_removed
    @old_objects << DummyCodeObject.new('m')
    assert_changes 'm' => :removed
  end
  
  def test_added
    @new_objects << DummyCodeObject.new('m')
    assert_changes 'm' => :added
  end
  
  def test_changed
    @old_objects << DummyCodeObject.new('m',nil,s(:a))
    @new_objects << DummyCodeObject.new('m',nil,s(:b))
    assert_changes 'm' => :changed
  end
  
  def test_no_change
    @old_objects << DummyCodeObject.new('m',nil,s(:a))
    @new_objects << DummyCodeObject.new('m',nil,s(:a))
    assert_changes
    assert @changes.empty?
  end
  
private
  class DummyCodeObject < CodeObject    
    def signature
      name
    end
  end
  
  def assert_changes(sig_hash={})
    c = CodeComparison.new(
      code_objects_by_sig(@old_objects),
      code_objects_by_sig(@new_objects)
    )
    
    change_hash = {}
    @changes = c.changes
    @changes.each{|change| change_hash[change.signature] = change.operation}
    sig_hash.each do |sig, operation|
      assert_equal operation, change_hash[sig], "#{sig} should have been #{operation}"
    end
  end
    
  def code_objects_by_sig(code_objects)
    h = {}
    code_objects.each{|o| h[o.signature] = o}
    h
  end
end
