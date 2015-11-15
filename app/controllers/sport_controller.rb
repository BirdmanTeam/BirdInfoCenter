class SportController < ApplicationController

  def index
    @weather_api = weather_api(922221)
    @sport = News.where(:branch => 'Sport').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
    @popular = @sport.where(:popular => true)
  end

end
