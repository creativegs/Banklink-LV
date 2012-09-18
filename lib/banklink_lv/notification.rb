module Banklink
  
  class Notification
    include Banklink::Common
    attr_accessor :params
    attr_accessor :raw
    
    # set this to an array in the subclass, to specify which IPs are allowed to send requests
    attr_accessor :production_ips

    def initialize(post, options = {})
      @options = options
      empty!
      parse(post)
    end

    def gross_cents
      (gross.to_f * 100.0).round
    end

    # This combines the gross and currency and returns a proper Money object. 
    # this requires the money library located at http://dist.leetsoft.com/api/money
    def amount
      return gross_cents
    end

    # reset the notification. 
    def empty!
      @params  = Hash.new
      @raw     = ""      
    end
    
    # Check if the request comes from an official IP
    def valid_sender?(ip)
      return true if Rails.env == :test || production_ips.blank?
      production_ips.include?(ip)
    end
    
        # A helper method to parse the raw post of the request & return
    # the right Notification subclass based on the sender id.
    #def self.get_notification(http_raw_data)
    #  params = ActiveMerchant::Billing::Integrations::Notification.new(http_raw_data).params
    #  Banklink.get_class(params)::Notification.new(http_raw_data)
    #end
    
    def get_data_string
      generate_data_string(params['VK_SERVICE'], params)
    end
  
    def bank_signature_valid?(bank_signature, service_msg_number, sigparams)
      SwedbankLv.get_bank_public_key.verify(OpenSSL::Digest::SHA1.new, bank_signature, generate_data_string(service_msg_number, sigparams))
    end
  
    def complete?
      params['VK_SERVICE'] == '1101'
    end
    
    def wait?
      params['VK_SERVICE'] == '1201'
    end
    
    def failed?
      params['VK_SERVICE'] == '1901'
    end
  
    def currency
      params['VK_CURR']
    end
  
    # The order id we passed to the form helper.
    def item_id
      params['VK_STAMP']
    end
  
    def transaction_id
      params['VK_T_NO']
    end
    
    def sender_name
      params['VK_SND_NAME']
    end
    
    def sender_bank_account
      params['VK_SND_ACC']
    end
    
    def reciever_name
      params['VK_REC_NAME']
    end
    
    def reciever_bank_account
      params['VK_REC_ACC']
    end
  
    # When was this payment received by the client.
    # We're expecting a dd.mm.yyyy format.
    def received_at
      date = params['VK_T_DATE']
      return nil unless date
      day, month, year = *date.split('.').map(&:to_i)
      Date.civil(year, month, day)
    end
  
    def signature
      Base64.decode64(params['VK_MAC'])
    end
  
    # The money amount we received, string.
    def gross
      params['VK_AMOUNT']
    end
  
    # Was this a test transaction?
    def test?
      params['VK_REC_ID'] == 'testvpos'
    end
  
    # TODO what should be here?
    def status
      complete? ? 'Completed' : 'Failed'
    end
  
    # If our request was sent automatically by the bank (true) or manually
    # by the user triggering the callback by pressing a "return" button (false).
    def automatic?
      params['VK_AUTO'].upcase == 'Y'
    end
  
    def success?
      acknowledge && complete?
    end
  
    # We don't actually acknowledge the notification by making another request ourself,
    # instead, we check the notification by checking the signature that came with the notification.
    # This method has to be called when handling the notification & deciding whether to process the order.
    # Example:
    #
    #   def notify
    #     notify = Notification.new(params)
    #
    #     if notify.acknowledge
    #       ... process order ... if notify.complete?
    #     else
    #       ... log possible hacking attempt ...
    #     end
    def acknowledge
      bank_signature_valid?(signature, params['VK_SERVICE'], params)
    end
    
    
    private

    # Take the posted data and move the relevant data into a hash
    def parse(post)
      @raw = post.to_s
      puts "====== FROM BANK ======"
      for line in @raw.split('&')    
        key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
        params[key] = CGI.unescape(value)
        
        puts "<#{key}> #{params[key]}"        
      end
      puts "======================="
    end
  end
end
  