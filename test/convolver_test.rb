require 'test/unit'
require 'test/unit/ui/console/testrunner'

require File.expand_path(File.dirname(__FILE__) + '/../nraster')
require File.expand_path(File.dirname(__FILE__) + '/../convolver')


class ConvolverTest < Test::Unit::TestCase
  def setup
    @large_constant_raster = Pixelate::Raster.new(1024, 1024)
    # since we are doing assignments to the entire instance var let's make sure
    # that the type is retained as a Raster by explicitly referencing the
    # underlying buffer rather than just using the DelegateClass functionality
    @large_constant_raster.buffer = @large_constant_raster.buffer + 1
    @large_constant_raster.buffer = @large_constant_raster.buffer

    @large_random_raster = Pixelate::Raster.new(1024, 1024)
    @large_random_raster.buffer.random
    
    @small_constant_raster = Pixelate::Raster.new(256, 256)
    # since we are doing assignments to the entire instance var let's make sure
    # that the type is retained as a Raster by explicitly referencing the
    # underlying buffer rather than just using the DelegateClass functionality
    @small_constant_raster.buffer = @large_constant_raster.buffer + 1
    @small_constant_raster.buffer = @large_constant_raster.buffer
    
    @boxcar_average_kernel = NArray.float(33, 33)
    @boxcar_average_kernel[8..23, 8..23] = 1
    @boxcar_average_kernel = @boxcar_average_kernel / @boxcar_average_kernel.sum
  end
  
  def test_initialization
    assert_nothing_raised {
      convolver = Pixelate::Convolver.new(@large_random_raster, @boxcar_average_kernel, 256)
      assert_equal [1024+256, 1024+256], convolver.raster.shape, 
        "After initialization the stored raster has the wrong dimensions"
      assert_equal [512, 512], convolver.kernel.shape,
        "After initialization the stored linear convolution kernel has the wrong dimensions"
    }
  end
  
  def test_output_dimensions
    assert_nothing_raised {
      convolver = Pixelate::Convolver.new(@large_random_raster, @boxcar_average_kernel, 256)
      output = convolver.convolve
      
      assert_equal @large_random_raster.shape, output.shape,
        "Convolution changed the dimensions of the raster (which is bad)."
        
      convolver = Pixelate::Convolver.new(@small_constant_raster, @boxcar_average_kernel, 256)
      output = convolver.convolve

      assert_equal @large_random_raster.shape, output.shape,
        "Convolution changed the dimensions of the raster (which is bad)."
    }    
  end
  
  def test_output_macro_validity
    assert_nothing_raised {
      assert_equal 1, @boxcar_average_kernel.sum, "The boxcar averaging kernel shouldn't rescale the image"
      convolver = Pixelate::Convolver.new(@large_constant_raster, @boxcar_average_kernel, 256)      
      assert_equal @large_constant_raster.buffer.sum, convolver.raster.sum
        "Integrated intensity changes after initialization"
        
      output = convolver.convolve

      assert_equal convolver.raster.sum, convolver.result.sum, 
        "Integrated intesnity changed after convolution when it shouldn't have" 
      
      assert_equal (NArray.float(1024-64, 1024-64) + 1).sum, output[32..(1024-33), 32..(1024-33)].sum
    }
  end
end