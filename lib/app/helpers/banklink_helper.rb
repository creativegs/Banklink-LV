module Banklink
  module ActionViewHelper
    include Banklink
    
    def payment_service_for(order, account, options = {}, &proc)          
      raise ArgumentError, "Missing block" unless block_given?
  
      result = []
      result << form_tag(SwedbankLv.service_url, options.delete(:html) || {})
      
      service = Helper.new(order, account, options)
  
      result << capture(service, &proc)
  
      service.form_fields.each do |field, value|
        result << hidden_field_tag(field, value)
      end
     
      result << '</form>'
      result= result.join("\n")
      
      concat(result.respond_to?(:html_safe) ? result.html_safe : result)
      nil
    end
  end
end