# NArray-based raster processing library for use with the expression-parser
# library.  
#
# Author:: Pramukta Kumar (mailto: prak@mac.com)
# Copyright:: Pramukta Kumar
# License:: MIT Public License
#
require 'test/unit'
require 'test/unit/ui/console/testrunner'

require File.expand_path(File.dirname(__FILE__) + '/nraster')

class NRasterTest < Test::Unit::TestCase
  def test_truth
    assert(true)
  end
end