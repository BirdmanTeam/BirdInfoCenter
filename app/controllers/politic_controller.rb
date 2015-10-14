require 'open-uri'

class PoliticController < ApplicationController

  def index
    @weather_api = weather_api
    @politic = News.where(:branch => 'Politic').paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

end
