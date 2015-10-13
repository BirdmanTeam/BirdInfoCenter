require 'open-uri'

class MusicController < ApplicationController

  def index
    @weather_api = weather_api
    @music = News.where(:branch => 'Music')
  end

end