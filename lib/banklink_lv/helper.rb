module Banklink #:nodoc:
 class Helper
    attr_reader :fields
    include Banklink::Common
   
    def initialize(order, account, options = {})
    
      @options = options
      @fields = {}
      
      @options['VK_SND_ID'] = account
      @options['VK_STAMP'] = order
      @options['VK_AMOUNT'] = options[:amount]
      @options['VK_CURR'] = options[:currency]
      @options['VK_RETURN'] = options[:return]
      @options['VK_REF'] = options[:reference] || ""
      @options['VK_MSG'] = options[:message]
      @options['VK_LANG'] = options[:lang] if options[:lang]
      
      if options[:service_msg_number]
        @service_msg_number = options.delete(:service_msg_number)
      else
        @service_msg_number = default_service_msg_number
      end

      add_required_params
      add_vk_mac
      add_charset_field
      add_return_url_field
      add_lang_field
    end
    
    
    def form_fields
      @fields
    end
    
    def self.mapping(attribute, options = {})
      self.mappings ||= {}
      self.mappings[attribute] = options
    end

    def add_field(name, value)
      return if name.blank? || value.blank?
      @fields[name.to_s] = value.to_s
    end

    def add_vk_mac
      # Signature used to validate previous parameters
      add_field('VK_MAC', generate_mac(@service_msg_number, form_fields))
    end
    
    def add_return_url_field
      add_field('VK_RETURN', @options['VK_RETURN'])
    end
    
    def add_lang_field
      if @options['VK_LANG']
        add_field(vk_lang_param, @options['VK_LANG'])
      else
        add_field vk_lang_param, vk_lang
      end
    end

    def add_charset_field
      add_field vk_charset_param, vk_charset
    end
 
    def add_required_params
      required_params = Banklink.required_service_params[@service_msg_number]
      required_params.each do |param|
        param_value = (@options.delete(param) || send(param.to_s.downcase)).to_s
        add_field param, encode_to_utf8(param_value)
      end
    end

    # Default parameters
    def vk_charset
      'UTF-8'
    end

    def vk_charset_param
      'VK_ENCODING'
    end
    
    def vk_lang
      'LAT'
    end

    def vk_lang_param
      'VK_LANG'
    end

    def vk_service
      @service_msg_number
    end

    def vk_version
      '008'
    end

    # Default service message number.
    # Use '1002' because it requires the least amount of parameters.
    def default_service_msg_number
      1002
    end

    private
    # Iconv converter to convert from utf8 to
    # the charset the bank api expects.
    
    def encode_to_utf8 string
      string.encode('UTF-8', :invalid => :replace, :replace => '').encode('UTF-8')
    end
    
  end
end