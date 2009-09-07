# NArray-based raster processing library for use with the expression-parser
# library.  
#
# Author:: Pramukta Kumar (mailto: prak@mac.com)
# Copyright:: Pramukta Kumar
# License:: MIT Public License
#
require  File.expand_path(File.dirname(__FILE__) + '/nraster')
require  File.expand_path(File.dirname(__FILE__) + '/convolver')

# :nodoc:
module Pixelate
  # Support module for mixing into an expression-parse interpreter
  module FunctionTokens
    # a list of available function symbols
    def functions
       [:gaussian, :convolve]
    end
  end
  module Functions
    # convolution entry point
    def convolve(raster, kernel)
      c = Convolver.new(raster, kernel, 256)
      Pixelate::Raster.from_narray(c.convolve)
    end
    # generate a gaussian kernel where the specified radius refers to the 
    # standard deviation of the distribution
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
    # # generate a Sobel X Gradient Kernel which can be used for edge detection
    # def sobelx
    #   g = NArray.to_na([[1, 0, -1],
    #                     [2, 0, -2],
    #                     [1, 0, -1]]).to_f;
    # end
    # # generate a Sobel Y Gradient Kernel which can be used for edge detection
    # def sobely
    #   g = NArray.to_na([[1,   2,  1],
    #                     [0,   0,  0],
    #                     [-1, -2, -1]]).to_f;
    # end
  end
end