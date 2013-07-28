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

  get '/:name' do
    if update_a_record params[:name]
      redirect to('/')
    else
      halt 400, 'invalid name'
    end
  end
end
end
