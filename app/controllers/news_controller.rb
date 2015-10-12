require 'weather_api'

class NewsController < ApplicationController
  include WeatherApi

  def index
    @weather_api = weather_api
  end

end

