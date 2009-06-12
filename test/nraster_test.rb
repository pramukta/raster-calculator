require 'test/unit'
require 'test/unit/ui/console/testrunner'

require File.expand_path(File.dirname(__FILE__) + '/nraster')

class NRasterTest < Test::Unit::TestCase
  def test_truth
    assert(true)
  end
end

Test::Unit::UI::Console::TestRunner.run(NRasterTest)