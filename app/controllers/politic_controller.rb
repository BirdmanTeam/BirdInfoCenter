require 'open-uri'

class PoliticController < ApplicationController

  def index
    @weather_api = weather_api(922221)
    @politic = News.where(:branch => 'Politic').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

end
