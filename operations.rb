require  File.expand_path(File.dirname(__FILE__) + '/nraster')
module Pixelate
  module Operations
    def operators
      [:+, :-, :*, :/, '^'.to_sym]
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
  end
end