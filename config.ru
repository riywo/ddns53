$:.unshift File.expand_path("../lib", __FILE__)
require 'ddns53'
require 'rack/auth/digest/md5'
require 'digest/md5'
require 'dotenv'
Dotenv.load

REALM = "ddns53"

use Rack::Auth::Digest::MD5, {
  :realm            => REALM,
  :opaque           => "",
  :passwords_hashed => true,
} do |user|
  Digest::MD5.new.update('%s:%s:%s' % [ENV['DDNS53_USER'], REALM, ENV['DDNS53_PASS']])
end

run Ddns53
