require 'delegate'

require 'rubygems'

require 'rmagick'
require 'narray'

module Pixelate
  class Raster < DelegateClass(NArray)
    attr_accessor :buffer
    def initialize(width, height)
      super(@buffer = NArray.float(width, height))
    end
    
    def self.from_narray(data)
      raster = Raster.new(data.shape[0], data.shape[1])
      raster.buffer[0..(data.shape[0]-1), 0..(data.shape[1]-1)] = data
      return raster
    end
    
    def width; self.shape[0]; end
    def height; self.shape[1]; end
            
    def get(x,y)
      self[x.floor,y.floor]
    end
    
    def set(x,y,z)
      # puts "#{x}, #{y}, #{self.width}, #{self.height}"
      self[x.floor,y.floor] = z
    end
    
    def minimum
      @min ||= self.min
    end
    
    def maximum
      @max ||= self.max
    end
    
    def recalc_min_and_max
      @min = self.min
      @max = self.max
      [@min, @max]
    end
    
    def to_image(colormap=DEFAULT_COLORMAP, range=self.recalc_min_and_max)
      min, max = range
      tmp = self.reshape(self.width*self.height)
      tmp = (tmp - min)/(max - min)
      image = Magick::Image.constitute(self.width, self.height, "I", tmp)
      lut = Magick::Image.constitute(colormap.length/4, 1, "RGBA", colormap)
      image.clut_channel(lut)
      return(image)
    end
    
    def self._load(data)
      pixels_array = data.unpack("IIE*")
      width = pixels_array.shift; height = pixels_array.shift
      pixels = NArray.to_na(pixels_array).reshape(width, height)
      raster = Raster.from_narray(pixels)
      return raster
    end
    
    def _dump(depth)
      data = self.buffer.reshape(self.width * self.height).to_a
      data.unshift(self.height); data.unshift(self.width)
      data.pack("IIE*")
    end
    
    private
    DEFAULT_COLORMAP = [256, 512, 256, 65535, 256, 512, 256, 65535, 256, 768, 256, 65535, 256, 1024, 256, 65535, 256, 1280, 256, 65535, 256, 1536, 256, 65535, 256, 1792, 256, 65535, 256, 2048, 256, 65535, 256, 2304, 256, 65535, 256, 2560, 256, 65535, 256, 2816, 256, 65535, 256, 3072, 256, 65535, 256, 3328, 256, 65535, 256, 3584, 256, 65535, 256, 3840, 256, 65535, 256, 4096, 256, 65535, 256, 4352, 256, 65535, 256, 4608, 256, 65535, 256, 4864, 256, 65535, 256, 5120, 256, 65535, 256, 5376, 256, 65535, 256, 5632, 256, 65535, 256, 5888, 256, 65535, 256, 6144, 256, 65535, 256, 6400, 256, 65535, 256, 6656, 256, 65535, 256, 6912, 256, 65535, 256, 7168, 256, 65535, 256, 7424, 256, 65535, 256, 7680, 256, 65535, 256, 7936, 256, 65535, 256, 8192, 256, 65535, 256, 8448, 256, 65535, 256, 8704, 256, 65535, 256, 8960, 256, 65535, 256, 9216, 256, 65535, 256, 9472, 256, 65535, 256, 9728, 256, 65535, 256, 9984, 256, 65535, 256, 10240, 256, 65535, 256, 10496, 256, 65535, 256, 10752, 256, 65535, 256, 11008, 256, 65535, 256, 11264, 256, 65535, 256, 11520, 256, 65535, 256, 11776, 256, 65535, 256, 12032, 256, 65535, 256, 12288, 256, 65535, 256, 12544, 256, 65535, 256, 12800, 256, 65535, 256, 13056, 256, 65535, 256, 13312, 256, 65535, 256, 13568, 256, 65535, 256, 13824, 256, 65535, 256, 14080, 256, 65535, 256, 14336, 256, 65535, 256, 14592, 256, 65535, 256, 14848, 256, 65535, 256, 15104, 256, 65535, 256, 15360, 256, 65535, 256, 15616, 256, 65535, 256, 15872, 256, 65535, 256, 16128, 256, 65535, 256, 16384, 256, 65535, 512, 16384, 512, 65535, 1024, 16128, 1024, 65535, 1536, 15872, 1536, 65535, 2048, 15616, 2048, 65535, 2560, 15360, 2560, 65535, 3072, 15104, 3072, 65535, 3584, 14848, 3584, 65535, 4096, 14592, 4096, 65535, 4608, 14336, 4608, 65535, 5120, 14080, 5120, 65535, 5632, 13824, 5632, 65535, 6144, 13568, 6144, 65535, 6656, 13312, 6656, 65535, 7168, 13056, 7168, 65535, 7680, 12800, 7680, 65535, 8192, 12544, 8192, 65535, 8704, 12288, 8704, 65535, 9216, 12032, 9216, 65535, 9728, 11776, 9728, 65535, 10240, 11520, 10240, 65535, 10752, 11264, 10752, 65535, 11264, 11008, 11264, 65535, 11776, 10752, 11776, 65535, 12288, 10496, 12288, 65535, 12800, 10240, 12800, 65535, 13312, 9984, 13312, 65535, 13824, 9728, 13824, 65535, 14336, 9472, 14336, 65535, 14848, 9216, 14848, 65535, 15360, 8960, 15360, 65535, 15872, 8704, 15872, 65535, 16384, 8448, 16384, 65535, 16640, 8192, 16640, 65535, 17152, 7936, 17152, 65535, 17664, 7680, 17664, 65535, 18176, 7424, 18176, 65535, 18688, 7168, 18688, 65535, 19200, 6912, 19200, 65535, 19712, 6656, 19712, 65535, 20224, 6400, 20224, 65535, 20736, 6144, 20736, 65535, 21248, 5888, 21248, 65535, 21760, 5632, 21760, 65535, 22272, 5376, 22272, 65535, 22784, 5120, 22784, 65535, 23296, 4864, 23296, 65535, 23808, 4608, 23808, 65535, 24320, 4352, 24320, 65535, 24832, 4096, 24832, 65535, 25344, 3840, 25344, 65535, 25856, 3584, 25856, 65535, 26368, 3328, 26368, 65535, 26880, 3072, 26880, 65535, 27392, 2816, 27392, 65535, 27904, 2560, 27904, 65535, 28416, 2304, 28416, 65535, 28928, 2048, 28928, 65535, 29440, 1792, 29440, 65535, 29952, 1536, 29952, 65535, 30464, 1280, 30464, 65535, 30976, 1024, 30976, 65535, 31488, 768, 31488, 65535, 32000, 512, 32000, 65535, 32512, 256, 32512, 65535, 33024, 256, 32000, 65535, 33536, 768, 31488, 65535, 34048, 1280, 30976, 65535, 34560, 1792, 30464, 65535, 35072, 2304, 29952, 65535, 35584, 2816, 29440, 65535, 36096, 3328, 28928, 65535, 36608, 3840, 28416, 65535, 37120, 4352, 27904, 65535, 37632, 4864, 27392, 65535, 38144, 5376, 26880, 65535, 38656, 5888, 26368, 65535, 39168, 6400, 25856, 65535, 39680, 6912, 25344, 65535, 40192, 7424, 24832, 65535, 40704, 7936, 24320, 65535, 41216, 8448, 23808, 65535, 41728, 8960, 23296, 65535, 42240, 9472, 22784, 65535, 42752, 9984, 22272, 65535, 43264, 10496, 21760, 65535, 43776, 11008, 21248, 65535, 44288, 11520, 20736, 65535, 44800, 12032, 20224, 65535, 45312, 12544, 19712, 65535, 45824, 13056, 19200, 65535, 46336, 13568, 18688, 65535, 46848, 14080, 18176, 65535, 47360, 14592, 17664, 65535, 47872, 15104, 17152, 65535, 48384, 15616, 16640, 65535, 48896, 16128, 16384, 65535, 49152, 16384, 15872, 65535, 49664, 16896, 15360, 65535, 50176, 17408, 14848, 65535, 50688, 17920, 14336, 65535, 51200, 18432, 13824, 65535, 51712, 18944, 13312, 65535, 52224, 19456, 12800, 65535, 52736, 19968, 12288, 65535, 53248, 20480, 11776, 65535, 53760, 20992, 11264, 65535, 54272, 21504, 10752, 65535, 54784, 22016, 10240, 65535, 55296, 22528, 9728, 65535, 55808, 23040, 9216, 65535, 56320, 23552, 8704, 65535, 56832, 24064, 8192, 65535, 57344, 24576, 7680, 65535, 57856, 25088, 7168, 65535, 58368, 25600, 6656, 65535, 58880, 26112, 6144, 65535, 59392, 26624, 5632, 65535, 59904, 27136, 5120, 65535, 60416, 27648, 4608, 65535, 60928, 28160, 4096, 65535, 61440, 28672, 3584, 65535, 61952, 29184, 3072, 65535, 62464, 29696, 2560, 65535, 62976, 30208, 2048, 65535, 63488, 30720, 1536, 65535, 64000, 31232, 1024, 65535, 64512, 31744, 512, 65535, 65024, 32256, 256, 65535, 65024, 32768, 1024, 65535, 65024, 33280, 2048, 65535, 65024, 33792, 3072, 65535, 65024, 34304, 4096, 65535, 65024, 34816, 5120, 65535, 65024, 35328, 6144, 65535, 65024, 35840, 7168, 65535, 65024, 36352, 8192, 65535, 65024, 36864, 9216, 65535, 65024, 37376, 10240, 65535, 65024, 37888, 11264, 65535, 65024, 38400, 12288, 65535, 65024, 38912, 13312, 65535, 65024, 39424, 14336, 65535, 65024, 39936, 15360, 65535, 65024, 40448, 16384, 65535, 65024, 40960, 17152, 65535, 65024, 41472, 18176, 65535, 65024, 41984, 19200, 65535, 65024, 42496, 20224, 65535, 65024, 43008, 21248, 65535, 65024, 43520, 22272, 65535, 65024, 44032, 23296, 65535, 65024, 44544, 24320, 65535, 65024, 45056, 25344, 65535, 65024, 45568, 26368, 65535, 65024, 46080, 27392, 65535, 65024, 46592, 28416, 65535, 65024, 47104, 29440, 65535, 65024, 47616, 30464, 65535, 65024, 48128, 31488, 65535, 65024, 48640, 32512, 65535, 65024, 48896, 33536, 65535, 65024, 49408, 34560, 65535, 65024, 49920, 35584, 65535, 65024, 50432, 36608, 65535, 65024, 50944, 37632, 65535, 65024, 51456, 38656, 65535, 65024, 51968, 39680, 65535, 65024, 52480, 40704, 65535, 65024, 52992, 41728, 65535, 65024, 53504, 42752, 65535, 65024, 54016, 43776, 65535, 65024, 54528, 44800, 65535, 65024, 55040, 45824, 65535, 65024, 55552, 46848, 65535, 65024, 56064, 47872, 65535, 65024, 56576, 48896, 65535, 65024, 57088, 49664, 65535, 65024, 57600, 50688, 65535, 65024, 58112, 51712, 65535, 65024, 58624, 52736, 65535, 65024, 59136, 53760, 65535, 65024, 59648, 54784, 65535, 65024, 60160, 55808, 65535, 65024, 60672, 56832, 65535, 65024, 61184, 57856, 65535, 65024, 61696, 58880, 65535, 65024, 62208, 59904, 65535, 65024, 62720, 60928, 65535, 65024, 63232, 61952, 65535, 65024, 63744, 62976, 65535, 65024, 64256, 64000, 65535, 65024, 64256, 64000, 65535]
    end
end