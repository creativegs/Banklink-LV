ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
 
require 'test/unit'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

require File.dirname(__FILE__) + '/../rails/init'

# default params
PARAMS_1002 = {'VK_SERVICE' => 'foo', 'VK_VERSION' => 'bar', 'VK_SND_ID' => 'goo', 'VK_STAMP' => 'tooboo', 'VK_AMOUNT' => '10565', 'VK_CURR' => 'LVL', 'VK_REF' => 'dsa', 'VK_MSG' => 'test'} 

SwedbankLv.test_private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQC+AROlXiRvi1T7Q9fAh0Lw73szAn26mqfKDqd6Bdplq3v+gVWC
3v0+bgtfNakRE/UVYOxEA0z0viqRpKzPuNy8OstTMe8fFKs19NW8lBYik6NzJ4Bk
+B6VmovOm0nJLQJytXKiJyuHP9DqPOVmP8S+azzX7Uqzov1nxo9fvH7y2QIDAQAB
AoGAFhbD9O6r57fYCloJxB01gBMnTHfWrBH8vbXUbJAvorA7+wuIKG3KHS7n7Yqs
fArI7FJXRVTo5m8RPdtaJ9ADAT9rjAi3A17TaEueyJl+B/hjHYhsd8MeFhTb2fh0
rY3F6diL8U/YDbiAIegnKO0zcc6ynJrsQZvzb6DlY/CLPe0CQQD3KXJzw1ZfJ1ts
c370b/ZC1YrRURw41Q0I8ljYJ8EJw/ngVxrnCIsd43bRnOVp9guJrjTQRkhDC3Gn
J2Y0+42LAkEAxMxmh7QY4nItBTS0fe1KCat4VDxhyxYEhZKlGDhxW75vNROrripB
1ZfBsq5xkY2MM9R7WKmL7SpStrUPIvEVqwJBAOXA4ISd61cupbytrDEbNscv7Afh
pyNpYOGVLmNYqQgj5c7WCcsD1RYmkRgPCe8y6czFZJDLFHdGVxLz+/16bTsCQC9J
Ob2TnYMTkhO1JUU4tdh69e+vjoPgp3d80+Rs83fq2wey0UaI6saqryUC21Dw5OYz
QOv92RxEVhmGibuIl/8CQCiYrzwlZJDlsKrWPZT0E8rzNmLZkhNHzYJP9S7x+FKk
m3gFeXEBgzGn9UOd6xIAp0p7A1XVBN8XzDMa09gSOks=
-----END RSA PRIVATE KEY-----
EOF

SwedbankLv.test_bank_certificate = <<EOF
-----BEGIN CERTIFICATE-----
MIIC0DCCAjmgAwIBAgIBADANBgkqhkiG9w0BAQUFADBVMQswCQYDVQQGEwJMVjEN
MAsGA1UECBMEUmlnYTENMAsGA1UEBxMEUmlnYTETMBEGA1UEChMKSEFOU0FCQU5L
QTETMBEGA1UEAxMKSEFOU0FCQU5LQTAeFw0wMTAyMDExMjMwMDZaFw0wMjAyMDEx
MjMwMDZaMFUxCzAJBgNVBAYTAkxWMQ0wCwYDVQQIEwRSaWdhMQ0wCwYDVQQHEwRS
aWdhMRMwEQYDVQQKEwpIQU5TQUJBTktBMRMwEQYDVQQDEwpIQU5TQUJBTktBMIGf
MA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDE+w2KupA9quH11ej1NAfczkL7TNme
HynzhNksmmtYtYNAuw3VmUzYJoKb2o5RoOQ1bizVBKTOKbSIexcLaLrGk/KeOm+j
ZSDusiF/HXm0rz/pTBmhIG8GlLCVH7u6E0huJP5scoaQuBtpWur2Y4bneKiETudK
2GrrsTYcKdiwYQIDAQABo4GvMIGsMB0GA1UdDgQWBBRciDFiPKgy0DcwzjDjDD++
VnEA3zB9BgNVHSMEdjB0gBRciDFiPKgy0DcwzjDjDD++VnEA36FZpFcwVTELMAkG
A1UEBhMCTFYxDTALBgNVBAgTBFJpZ2ExDTALBgNVBAcTBFJpZ2ExEzARBgNVBAoT
CkhBTlNBQkFOS0ExEzARBgNVBAMTCkhBTlNBQkFOS0GCAQAwDAYDVR0TBAUwAwEB
/zANBgkqhkiG9w0BAQUFAAOBgQAJFEudrjjLvKDVfcHR04BlxhhodZW4jRHHiOCT
xb07T6gighi+GcNb9EZFObtKZtMDoTY6JrhDsT/f4kCJkL+XpCIKMHym2D1MW7Zc
eOUNgEjYgX5hKUQCLVH54SRN96w2HFYRXpZPD4r8JYrVWEksSABt9A7wLo85Tiac
kTbuTA==
-----END CERTIFICATE-----
EOF

SwedbankLv.test_url = 'https://banklink.lv' 
 
def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
 
  db_adapter = ENV['DB']
 
  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require 'rubygems'
      require 'sqlite'
      'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
        'sqlite3'
      rescue MissingSourceFile
      end
    end
 
  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end
 
  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/schema.rb")
end