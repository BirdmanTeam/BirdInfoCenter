class NewsController < ApplicationController

  def index
    @weather_api = weather_api
    @news = News.paginate(:page => params[:page], :per_page => 30)
  end

  def new
  end

  def parse_news
    update_music

    redirect_to :back
  end

  def show
    @article = News.find(params[:id])
  end

  private

  def update_music
    url = open('http://www.rollingstone.com/music/news')

    doc = Nokogiri::HTML(url)

    doc.css('li.primary-list-item').each do |link|
      article_url = open('http://www.rollingstone.com'+link.at_css('.list-item-hd a')['href'])
      article_doc = Nokogiri::HTML(article_url)

      @title = article_doc.css('.article-title').text
      @sub_title = article_doc.css('.article-sub-title').text

      date_unformat = link.css('span.datestamp').text
      month = Date::MONTHNAMES.index(date_unformat.split(' ')[0])
      day = (date_unformat.split(' ')[1][0..-2].to_i+1).to_s
      year = date_unformat.split(' ')[2]
      @date = ("#{day}/#{month}/#{year}").to_time

      @content = article_doc.css('.article-content p').text
      News.create(name: @title, description: @content, branch: 'Music', date: @date)
    end
  end

  def update_sport

  end

  def update_economic

  end

  def update_politic

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_news
    @article = News.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:name, :description, :branch, :popular, :date)
  end

end

