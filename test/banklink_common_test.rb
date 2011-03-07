require File.dirname(__FILE__) + '/test_helper'

class BanklinkCommonTest < Test::Unit::TestCase
  include Banklink::Common
  
  def test_should_decide_string_lenght
    assert_equal "006", func_p("ARTŪRS")
  end
  
  def test_should_generate_data_string
    assert_equal "003foo003bar003goo006tooboo00510565003LVL003dsa004test", generate_data_string(1002, PARAMS_1002)
  end
  
end