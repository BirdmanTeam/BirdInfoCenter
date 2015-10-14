require 'open-uri'

class MusicController < ApplicationController

  def index
    @weather_api = weather_api
    @music = News.where(:branch => 'Music').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

end