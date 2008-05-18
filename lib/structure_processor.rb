class MethodSignuature
  def initialize name, classes=[], modules=[], instance=true
    @name = name
    @classes = classes.dup
    @modules = modules.dup
    @instance = instance
  end
  
  def to_s
    scope = (@modules + @classes).join("::")
    if @instance
      "#{scope}##{@name}"
    else
      "#{scope}.#{@name}"
    end
  end
  
  # The following are all just to quickly get hashing right
  # TODO: replace with real methods
  def hash
    self.to_s.hash
  end
  
  def <=> other
    self.to_s <=> other.to_s
  end
  
  def == other
    self.to_s == other.to_s
  end
  
  def eql? other
    self.to_s.eql? other.to_s
  end
end

class StructureProcessor < SexpProcessor
  attr_accessor :instance_methods
  
  def initialize
    super
    self.strict = false
    self.auto_shift_type = true
    @classes = []
    @modules = []
    @instance_methods = {}
  end
  
  def process_class(exp)
    name = exp.shift
    super_class = exp.shift #?
    body = exp.shift
    @classes.unshift name
    result = s(:class, name, process(super_class), process(body))
    @classes.shift
    return result
  end
  
  def process_module(exp)
    name = exp.shift
    body = exp.shift
    @modules.unshift name
    result = s(:class, name, process(body))
    @modules.shift
    return result
  end
  
  def process_defn(exp)
    name = exp.shift
    args = process exp.shift
    body = process exp.shift

    #signature = "#{[@hierarchy].join('::')}##{name}"
    signature = MethodSignuature.new(name, @classes, @modules, true)
    @instance_methods[signature] = {:name=>name, :args=>args, :body=>body}
    
    return s(:defn, name, args, body)
  end
  
  def diff(other_processor)
    instance_method_diff = CodeComparison.new(self.instance_methods, other_processor.instance_methods).changes
  end
end