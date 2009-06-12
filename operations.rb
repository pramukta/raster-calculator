module Pixelate
  module Functions
    OPERATORS = [:+, :-, :*, :/, '^'.to_sym]
    def +(a,b)
      a + b
    end
    def -(a,b)
      a - b
    end
    def *(a,b)
      a * b
    end
    def /(a,b)
      a / b
    end
    def ^(a,b)
      a ** b
    end
  end
end