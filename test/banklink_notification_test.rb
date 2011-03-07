require File.dirname(__FILE__) + '/test_helper'

class BanklinkNotificationTest < Test::Unit::TestCase
  include Banklink

  def setup
    @swedbank = Banklink::Notification.new(http_raw_data2)
  end
  
  def test_data_string
    assert_equal "test", @swedbank.get_data_string
  end
  
  def test_acknowledgement
    assert_equal true, @swedbank.acknowledge
  end

  def test_accessors
    assert_equal true, @swedbank.complete?
    assert_equal 'Completed', @swedbank.status
    assert_equal "88", @swedbank.item_id
    assert_equal "2774", @swedbank.transaction_id
    assert_equal '33', @swedbank.gross
    assert_equal "EEK", @swedbank.currency
    assert_equal '26.11.2007', @swedbank.received_at.strftime("%d.%m.%Y")
    assert_equal true, @swedbank.test?
  end

  def test_compositions
    assert_equal 3300, @swedbank.amount
  end

  def test_acknowledgement_fail_with_params_changed
    @swedbank = Banklink::Notification.new(http_raw_data.gsub('VK_SND_ID=EYP', 'VK_SND_ID=EYS'))
    assert_equal false, @swedbank.acknowledge
  end

  private

  def http_raw_data
    "VK_SERVICE=1101&VK_VERSION=008&VK_SND_ID=EYP&VK_REC_ID=testvpos&VK_STAMP=88&VK_T_NO=2774&VK_AMOUNT=33&VK_CURR=EEK&VK_REC_ACC=10002050618003&VK_REC_NAME=ALLAS+ALLAR&VK_SND_ACC=10010046155012&VK_SND_NAME=t%C3%B5%C3%B5ger+%2C+Le%C3%B5p%C3%A4%C3%B6ld%C5%BE%C5%BD%C5%A1%C5%A0&VK_REF=123&VK_MSG=Porgandid&VK_T_DATE=26.11.2007&VK_MAC=LyCZRncu%2F%2BOi5nwzOkI6C9UMFohN6tSl3tLFyIJyNp2lGKBrDKZ2H8b%2BadU3XalzS7MwnAj8r%2FRhLpbsGNE5ysNyM4CKkSrsVzxoXbt9%2BB1foH9Rlp9LCeoR2H774f8UcMe9RVsE%2B%2BZfrEZzzXYyR1PXDCVOShQOAxlD9pbh8nk%3D&VK_LANG=EST&VK_RETURN=http%3A%2F%2F90.190.110.154%2Fseb_est%2Fnotify&VK_AUTO=N&VK_CHARSET=UTF-8&keel=EST&appname=UN3MIN&act=UPOSTEST2"
  end
  
  def http_raw_data2
    "VK_SND_NAME=ART%26%23362%3BRS+BRAU%26%23268%3BS&VK_ENCODING=ISO-8859-1&VK_SND_ACC=LV20HABA0551017320947&VK_AMOUNT=0.01&VK_MAC=FPYEMoc63Huz0XLNweii2eEZmhLn7BNSUlL8A3sQZUoASPZfG8rvufVbku%2BGEBy8FYHUBuo%2BpBQYgfrs0uABOBuS6tfwgax24tqmn4%2BIwMIf96BTSgUzV%2FEXipx3i%2BGO443lvazQ2LBnmMmff0BUzlF%2FKc2ScFX%2BwbsMOHnpbaY%3D&VK_AUTO=Y&VK_MSG=Testing+banklink&VK_REF=54&VK_REC_ID=IDEJMAJ&VK_STAMP=300&VK_CURR=LVL&VK_REC_NAME=VIDZEMES+INOV%26%23256%3BCIJU+UN+UZ%26%23325%3B%26%23274%3BM%26%23274%3BJDARB%26%23298%3BBAS+CENTRS&VK_SERVICE=1101&VK_LANG=LAT&VK_T_DATE=04.03.2011&VK_VERSION=008&VK_SND_ID=HP&VK_T_NO=123&VK_REC_ACC=LV73HABA0551030238841&encoding=ISO-8859-1"
  end
  
end