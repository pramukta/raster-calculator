requir  'nraster'
require 'convolver'
module Pixelate
  module Functions
    FUNCTIONS = [:gaussian, :convolve]
    def convolve(raster, kernel)
      c = Convolver.new(raster, kernel, 256)
      c.convolve
    end
    
    def gaussian(radius)
      g = NArray.float(2*radius+1, 2*radius+1)
      for i in 0..(g.shape[0]-1)
        for j in 0..(g.shape[1]-1)
          r = ((i - radius)**2 + (j - radius)**2).to_f
          g[i,j] = (1.0/(2*radius*Math.sqrt(2*3.141592654)))*Math.exp(-1*(r/(2*(radius)))**2)
        end
      end
      g
    end
  end
end