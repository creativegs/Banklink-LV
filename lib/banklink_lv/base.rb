class Hash
  def to_params
    map{ |k, v| URI.escape("#{k}=#{v}") }.join("&")
  end
end

module BanklinkLv
  
end