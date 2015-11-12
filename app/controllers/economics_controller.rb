require 'open-uri'

class EconomicsController < ApplicationController

  def index
    @weather_api = weather_api(922221)
    @economics = News.where(:branch => 'Economics').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

end
