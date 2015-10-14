require 'open-uri'

class EconomicController < ApplicationController

  def index
    @weather_api = weather_api
    @economic = News.where(:branch => 'Economic').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

end
