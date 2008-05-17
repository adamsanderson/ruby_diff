class StructureProcessor < SexpProcessor
  attr_accessor :defs
  
  def initialize
    super
    self.strict = false
    self.auto_shift_type = true
    @hierarchy = []
    @defs = {}
  end
  
  def process_class(exp)
    name = exp.shift
    super_class = exp.shift
    body = exp.shift
    @hierarchy.unshift name
    result = s(:class, name, process(super_class), process(body))
    @hierarchy.shift
    return result
  end
  
  def process_defn(exp)
    name = exp.shift
    args = process exp.shift
    body = process exp.shift

    signature = "#{[@hierarchy].join('::')}##{name}"
    @defs[signature] = {:name=>name, :args=>args, :body=>body}
    
    return s(:defn, name, args, body)
  end
  
  def diff(other_processor)
    CodeComparison.new(self.defs, other_processor.defs).changes
  end
end