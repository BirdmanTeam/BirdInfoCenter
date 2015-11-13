class MusicController < ApplicationController

  def index
    @weather_api = weather_api(922221)
    @music = News.where(:branch => 'Music').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
    @popular = @music.where(:popular => true)
  end

end