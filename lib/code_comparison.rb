CodeChange = Struct.new(:signature, :operation)

class CodeComparison
  def initialize(old_signatures, new_signatures)
    @old = old_signatures
    @new = new_signatures
  end
  
  def changes
    changes = []
    seen = Set.new
    @old.each do |sig, sexp|
      seen << sig
      if other_sexp = @new[sig]
        if sexp != other_sexp
          changes << changed(sig, sexp, sig, other_sexp)
        end
      else
        changes << removal(sig, sexp)
      end
    end
    
    @new.each do |sig, sexp|
      if !seen.include?(sig)
        changes << addition(sig, sexp)
      end
    end
    
    changes
  end
  
protected
  def addition(sig, sexp)
    CodeChange.new(sig, :added)
  end
  
  def removal(sig, sexp)
    CodeChange.new(sig, :removed)
  end
  
  def changed(old_sig, old_sexp, new_sig, new_sexp)
    CodeChange.new(old_sig, :changed)
  end
end