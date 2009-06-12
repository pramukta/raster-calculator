require 'nraster'
module Pixelate
  module Functions
    OPERATORS = [:+, :-, :*, :/, '^'.to_sym]
    def +(a,b)
      NRaster.from_narray(a + b)
    end
    def -(a,b)
      NRaster.from_narray(a - b)
    end
    def *(a,b)
      NRaster.from_narray(a * b)
    end
    def /(a,b)
      NRaster.from_narray(a / b)
    end
  end
end