# encoding: utf-8

require File.dirname(__FILE__) + '/test_helper'

class BanklinkCommonTest < Test::Unit::TestCase
  include Banklink::Common
  
  def test_should_decide_string_lenght
    assert_equal "007", func_p("ĀĒŪĪĻĶŠ")
  end
  
  def test_should_generate_data_string
    assert_equal "003foo003bar003goo006tooboo00510565003LVL003dsa005Āžēīū", generate_data_string(1002, PARAMS_1002)
  end
  
end