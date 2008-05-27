require 'test/unit'
require 'test/unit/testcase'
require File.expand_path(File.dirname(__FILE__) + "/../ruby_diff")

class StructureProcessorTestCase < Test::Unit::TestCase  
  def setup
    
  end
  
  def test_instance_method
    assert_signatures <<-CODE, ["A#method_1"]
      class A
        def method_1
        end
      end
    CODE
  end
  
  def test_instance_method_with_module
    assert_signatures <<-CODE, ["B::A#method_1"]
      module B
        class A
          def method_1
          end
        end
      end
    CODE
  end
  
  def test_unscoped_method
    assert_signatures <<-CODE, ["#method_1"]    
      def method_1
      end
    CODE
  end
  
  def test_class_method_self
    assert_signatures <<-CODE, ["A.method_1"]
      class A
        def self.method_1
        end
      end
    CODE
  end
  
  def test_class_method_self_explicit
    assert_signatures <<-CODE, ["A.method_1"]
      class A
        def A.method_1
        end
      end
    CODE
  end
  
  def test_class_method_append_self
    assert_signatures <<-CODE, ["A.method_1"]
      class A
        class << self
          def method_1
          end
        end
      end
    CODE
  end
  
  def assert_signatures(code, signatures, types=[MethodCode])
    sexp = ParseTree.new.parse_tree_for_string(code)
    processor = StructureProcessor.new()
    processor.process(* sexp)
    
    found_signatures = processor.code_objects.values.select{|co| types.include?(co.class)}.map{|key| key.signature }.sort
    assert_equal signatures.sort, found_signatures
  end
  
end