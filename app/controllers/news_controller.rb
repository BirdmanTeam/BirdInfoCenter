class NewsController < ApplicationController

  def index
    @weather_api = weather_api
    @news = News.paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

  def parse_news
    News.delete_all
    update_music
    update_economic
    redirect_to :back
  end

  def show
    @weather_api = weather_api
    @article = News.find(params[:id])
    @news = News.all
  end

  private

  def update_music
    count_of_pages = 2
    i = 1
    while i<=count_of_pages
      if i==1
        url = open('http://www.rollingstone.com/music/news')
      else
        url = open('http://www.rollingstone.com/music/news?page='+i.to_s)
      end
      doc = Nokogiri::HTML(url)

      doc.css('li.primary-list-item').each do |link|
        article_url = open('http://www.rollingstone.com'+link.at_css('.list-item-hd a')['href'])
        article_doc = Nokogiri::HTML(article_url)

        title = article_doc.css('.article-title').text

        date_unformat = link.css('span.datestamp').text
        month = Date::MONTHNAMES.index(date_unformat.split(' ')[0])
        day = (date_unformat.split(' ')[1][0..-2].to_i+1).to_s
        year = date_unformat.split(' ')[2]
        date = ("#{day}/#{month}/#{year}").to_time

        content = article_doc.css('.article-content p').text
        News.create(name: title, description: content, branch: 'Music', date: date)
      end
      i+=1
    end
  end

  def update_economic
    count_of_pages = 2
    i = 1
    while i<=count_of_pages
      if i==1
        url = open('http://www.cnbc.com/economy/')
      else
        url = open('http://www.cnbc.com/economy/?page='+i.to_s)
      end
      doc = Nokogiri::HTML(url)

      doc.css('li div.cnbcnewsstory').each do |link|
        article_url = open('http://www.cnbc.com'+link.at_css('.headline a')['href'])
        article_doc = Nokogiri::HTML(article_url)

        title = article_doc.css('.title').text
        # @sub_title = article_doc.css('.article-sub-title').text
        date_unformat = link.css('span.timestamp').text
        month = Date::ABBR_MONTHNAMES.index(date_unformat.split(' ')[2])
        day = (date_unformat.split(' ')[1].to_i+1).to_s
        year = date_unformat.split(' ')[3]
        date = ("#{day}/#{month}/#{year}").to_time

        content = article_doc.css('.group p').text
        News.create(name: title, description: content, branch: 'Economic', date: date)
      end
      i+=1
    end
  end

  def update_politic

  end

  def update_sport

  end

  def set_news
    @article = News.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:name, :description, :branch, :popular, :date)
  end

end

