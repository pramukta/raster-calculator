require 'rubygems'
require 'geo_ruby'
require File.expand_path(File.dirname(__FILE__) + '/nraster')

module Pixelate
  class RasterFactory
    attr_reader :raster
    attr_accessor :bbox
    def initialize(width, height, bbox)
      @raster = Raster.new(width, height)
      @bbox = bbox;
    end
    def srid
      bbox.srid
    end
    def add(geometry, value)
      if(!geometry.is_a?(GeoRuby::SimpleFeatures::Point))
        raise(StandardError, "Only Point Geometries are supported.")
      end
      i, j = convert_coord(geometry.x, geometry.y)
      raster.set(i, j, raster.get(i, j) + value)
    rescue IndexError
      nil
    end
    private
    def convert_coord(x, y)
      i = (raster.width*(x - bbox.lower_corner.x)/(bbox.upper_corner.x - bbox.lower_corner.x))
      j = (raster.height*(bbox.upper_corner.y - y)/(bbox.upper_corner.y - bbox.lower_corner.y))
      [i, j]
    end
  end
end