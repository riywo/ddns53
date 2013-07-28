$:.unshift File.expand_path("../lib", __FILE__)
require 'ddns53'
env = ENV['RACK_ENV'] || "development"

if env == 'development'
  require 'dotenv'
  Dotenv.load
end

REALM = "Authentication for ddns53"

Rack::Auth::Digest::Nonce::time_limit = 1
use Rack::Auth::Digest::MD5, {
  :realm            => REALM,
  :opaque           => "",
  :passwords_hashed => true,
} do |user|
  Digest::MD5.new.update('%s:%s:%s' % [ENV['DDNS53_USER'], REALM, ENV['DDNS53_PASS']])
end

run Ddns53
