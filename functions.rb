# NArray-based raster processing library for use with the expression-parser
# library.  
#
# Author:: Pramukta Kumar (mailto: prak@mac.com)
# Copyright:: Pramukta Kumar
# License:: MIT Public License
#
require  File.expand_path(File.dirname(__FILE__) + '/nraster')
require  File.expand_path(File.dirname(__FILE__) + '/convolver')

module Pixelate
  module Functions
    def functions
       [:gaussian, :convolve]
    end
    def convolve(raster, kernel)
      c = Convolver.new(raster, kernel, 256)
      Pixelate::Raster.from_narray(c.convolve)
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