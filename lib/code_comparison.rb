class CodeChange
  attr_reader :signature
  attr_reader :operation
  attr_reader :changes
  
  OPERATION_CHARS = {
    :added   => "+",
    :removed => "-",
    :changed => "c",
    :moved   => "m"   #Not used yet
  }
  
  def initialize(signature, operation, changes=[])
    @signature = signature
    @operation = operation
    @changes   = changes
  end
  
  def to_s(depth=1)
    this_change = "#{OPERATION_CHARS[self.operation]}#{"  "*depth}#{signature}"
    sub_changes = changes.map{|c| c.to_s(depth+1)}
    [this_change, sub_changes].flatten.join("\n")
  end
end

class CodeComparison
  def initialize(old_signatures, new_signatures)
    @old = old_signatures
    @new = new_signatures
  end
  
  def changes
    changes = []
    seen = Set.new
    @old.each do |sig, code_object|
      seen << sig
      if other_code_object = @new[sig]
        if code_object != other_code_object
          changes << changed(sig, code_object, sig, other_code_object)
        end
      else
        changes << removal(sig, code_object)
      end
    end
    
    @new.each do |sig, code_object|
      if !seen.include?(sig)
        changes << addition(sig, code_object)
      end
    end
    
    changes
  end
  
protected
  def addition(sig, code_object)
    CodeChange.new(sig, :added)
  end
  
  def removal(sig, code_object)
    CodeChange.new(sig, :removed)
  end
  
  def changed(old_sig, old_code_object, new_sig, new_code_object)
    CodeChange.new(old_sig, :changed, CodeComparison.new(
      old_code_object.child_signatures,
      new_code_object.child_signatures
    ).changes)
  end
end
