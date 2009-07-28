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
      Pixelate::Raster.from_narray(a.buffer + b.buffer)
    end
    def -(a,b)
      Pixelate::Raster.from_narray(a.buffer - b.buffer)
    end
    def *(a,b)
      Pixelate::Raster.from_narray(a.buffer * b.buffer)
    end
    def /(a,b)
      Pixelate::Raster.from_narray(a.buffer / b.buffer)
    end
    def >(a,b)
      Pixelate::Raster.from_narray(a.gt(b))
    end
    def >=(a,b)
      Pixelate::Raster.from_narray(a.ge(b))
    end
    def <(a,b)
      Pixelate::Raster.from_narray(a.lt(b))
    end
    def <=(a,b)
      Pixelate::Raster.from_narray(a.le(b))
    end
    def eq(a,b)      
      Pixelate::Raster.from_narray(a.eq(b))
    end
    def ne(a,b)
      Pixelate::Raster.from_narray(a.ne(b))
    end
  end
end