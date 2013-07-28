$:.unshift File.expand_path("../lib", __FILE__)
require 'rack'
env = ENV['RACK_ENV'] || "development"
if env == 'development'
  require 'dotenv'
  Dotenv.load
end

MANDATORY_ENV = %w{DDNS53_USER DDNS53_PASS AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY}
missing_env = MANDATORY_ENV.select { |key| !ENV.has_key?(key) }

if missing_env.size == 0
  REALM = "Authentication for ddns53"
  Rack::Auth::Digest::Nonce::time_limit = 1
  use Rack::Auth::Digest::MD5, {
    :realm            => REALM,
    :opaque           => "",
    :passwords_hashed => true,
  } do |user|
    Digest::MD5.new.update('%s:%s:%s' % [ENV['DDNS53_USER'], REALM, ENV['DDNS53_PASS']])
  end

  require 'ddns53/app'
  run Ddns53::App.new
else
  run Proc.new {[
    200,
    {'Content-Type' => 'text/plain'},
    ["Missing ENV: #{missing_env}\nSee also: https://github.com/riywo/ddns53/blob/master/README.md"]
  ]}
end
