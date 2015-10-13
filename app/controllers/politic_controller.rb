class PoliticController < ApplicationController

  def index
    @weather_api = weather_api
    @politic = News.where(:branch => 'Politic')
  end

end
