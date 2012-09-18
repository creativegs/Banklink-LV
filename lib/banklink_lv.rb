require 'banklink_lv/version'

require "rails"
require "active_support/dependencies"

require 'net/http'
require 'net/https'
require 'uri'

require 'digest'
require 'digest/md5'
require 'openssl'

require 'cgi'

# require 'banklink_lv/engine'
# require 'banklink_lv/core_ext'
require 'banklink_lv/banklink'
require 'banklink_lv/base'
require 'banklink_lv/helper'
require 'banklink_lv/swedbank'
require 'banklink_lv/notification'
require 'app/helpers/banklink_helper'

#include ActiveSupport

%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  # ActiveSupport::Dependencies.load_paths << path
  # ActiveSupport::Dependencies.load_once_paths.delete(path)
end