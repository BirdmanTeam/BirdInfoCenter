class HomeController < ApplicationController

  def index
    @weather_api = weather_api(922221)
    @news = News.paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
    @popular = @news.where(:popular => true)
  end

end
