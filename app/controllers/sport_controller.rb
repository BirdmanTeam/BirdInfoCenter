class SportController < ApplicationController

  def index
    @weather_api = weather_api
    @sport = News.where(:branch => 'Sport')
  end

end
