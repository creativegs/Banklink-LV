require File.dirname(__FILE__) + '/test_helper'

class BanklinkViewHelperTest < Test::Unit::TestCase
  include Banklink::ActionViewHelper
  
  def test_should_create_form
    options = {}
    options[:amount] = '1.55'
    options[:currency] = 'LVL'
    options[:return] = 'http://default/'
    options[:reference] = '54'
    options[:message] = 'Pay for smtx'
    
    # assert_equal "", payment_service_for(300, '300', options)
  end
  
end