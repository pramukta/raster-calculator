# NArray-based raster processing library for use with the expression-parser
# library.  
#
# Author:: Pramukta Kumar (mailto: prak@mac.com)
# Copyright:: Pramukta Kumar
# License:: MIT Public License
#
require  File.expand_path(File.dirname(__FILE__) + '/nraster')
module Pixelate
  module Operations
    def operators
      [:+, :-, :*, :/, '^'.to_sym, :>, :<, :>=, :<=, 'eq'.to_sym, 'ne'.to_sym]
    end
    def +(a,b)
      Pixelate::Raster.from_narray(a + b)
    end
    def -(a,b)
      Pixelate::Raster.from_narray(a - b)
    end
    def *(a,b)
      Pixelate::Raster.from_narray(a * b)
    end
    def /(a,b)
      Pixelate::Raster.from_narray(a / b)
    end
    def >(a,b)
      if(a.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(a.gt(b))
      elsif(b.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(b.lt(a))
      else
        (a > b) ? 1 : 0
      end
    end
    def >=(a,b)
      if(a.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(a.gte(b))
      elsif(b.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(b.lte(a))
      else
        (a >= b) ? 1 : 0
      end
    end
    def <(a,b)
      if(a.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(a.lt(b))
      elsif(b.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(b.gt(a))
      else
        (a < b) ? 1 : 0
      end
    end
    def <=(a,b)
      if(a.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(a.lte(b))
      elsif(b.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(b.gte(a))
      else
        (a <= b) ? 1 : 0
      end
    end
    def eq(a,b)      
      if(a.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(a.eq(b.to_f))
      elsif(b.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(b.eq(a.to_f))
      else
        (a == b) ? 1 : 0
      end
    end
    def ne(a,b)
      if(a.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(a.ne(b.to_f))
      elsif(b.is_a?(Pixelate::Raster))
        Pixelate::Raster.from_narray(b.ne(a.to_f))
      else
        (a != b) ? 1 : 0
      end
    end
  end
end