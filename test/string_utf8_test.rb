# encoding: utf-8

require File.dirname(__FILE__) + '/test_helper'
 
class StringUTF8Test < Test::Unit::TestCase
  def test_utf8_string_lenght
    assert_equal 10, "Āēīūķļņčšģ".length
  end
end