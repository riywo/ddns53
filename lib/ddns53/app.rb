require 'sinatra/base'
require 'slim/logic_less'
require 'ddns53/helper'

module Ddns53
class App < Sinatra::Base
  helpers Ddns53::Helper
  set :views, File.expand_path('../../../views', __FILE__)

  get '/' do
    slim :index
  end

  get '/:fqdn' do
    if update_a_record params[:fqdn]
      redirect to('/')
    else
      halt 400, 'invalid FQDN'
    end
  end
end
end
