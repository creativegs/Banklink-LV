module SwedbankLv

  # Raw X509 certificate of the bank, string format.
  mattr_accessor :bank_certificate
  mattr_accessor :test_bank_certificate
  # RSA public key of the bank, taken from the X509 certificate of the bank. OpenSSL container.
  def self.get_bank_public_key
    if Rails.env == 'production'
      cert = self.bank_certificate
    else
      cert = self.test_bank_certificate
    end
    OpenSSL::X509::Certificate.new(cert.gsub(/  /, '')).public_key
  end

  mattr_accessor :private_key
  mattr_accessor :test_private_key
  # Our RSA private key. OpenSSL container.
  def self.get_private_key
    if Rails.env == 'production'
      private_key = self.private_key
    else
      private_key = self.test_private_key
    end
    OpenSSL::PKey::RSA.new(private_key.gsub(/  /, ''))
  end

  mattr_accessor :test_url
  mattr_accessor :production_url
  def self.service_url
    mode = Rails.env
    case mode
    when 'production'
      self.production_url
    when 'test'
      self.test_url
    when 'development'
      self.production_url
    else
      self.production_url
      # raise StandardError, "Integration mode set to an invalid value: #{mode}"
    end
  end

  def self.notification(post)
    Notification.new(post)
  end

end