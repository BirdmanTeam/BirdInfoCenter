require 'open-uri'

class SportController < ApplicationController

  def index
    @weather_api = weather_api
    @sport = News.where(:branch => 'Sport').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

end
