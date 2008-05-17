class SexpWildCard < SexpMatchSpecial
  def === (o)
    return true
  end
  
  def == (o)
    return true
  end
  
end

def _?
  SexpWildCard.new
end

class Sexp
  def match(pattern, &block)
    if pattern == self
      block.call(self)
    end

    self.each do |subset|
      case subset
      when Sexp then
        subset.match(pattern, &block)
      end
    end
  end
end