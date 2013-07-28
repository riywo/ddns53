require 'sinatra/base'

class Ddns53 < Sinatra::Base
  get '/' do
    "ddns53"
  end
end
