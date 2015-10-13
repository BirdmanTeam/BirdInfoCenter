require 'open-uri'

class EconomicController < ApplicationController

  def index
    @weather_api = weather_api
    @economic = News.where(:branch => 'Economic')
  end

end
