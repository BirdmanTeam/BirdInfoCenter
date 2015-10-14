class NewsController < ApplicationController

  def index
    @weather_api = weather_api
    @news = News.paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

  def parse_news
    News.delete_all

    update_music(2)
    update_economic(2)
    update_politic(2)

    redirect_to :back
  end

  def show
    @weather_api = weather_api
    @article = News.find(params[:id])
    @news = News.all
  end

  private

  def update_music(count_of_pages)
    count_of_pages.times do |i|
      url = open('http://www.rollingstone.com/music/news?page=' + (i + 1).to_s)

      doc = Nokogiri::HTML(url)

      doc.css('li.primary-list-item').each do |link|
        article_url = open('http://www.rollingstone.com' + link.at_css('.list-item-hd a')['href'])
        article_doc = Nokogiri::HTML(article_url)

        title = article_doc.css('.article-title').text

        date_unformat = link.css('span.datestamp').text
        month = Date::MONTHNAMES.index(date_unformat.split[0])
        day = (date_unformat.split[1][0..-2].to_i + 1).to_s
        year = date_unformat.split[2]
        date = ("#{day}/#{month}/#{year}").to_time

        content = article_doc.css('.article-content p').text
        News.create(name: title, description: content, branch: 'Music', date: date)
      end
    end
  end

  def update_politic(count_of_pages)
    count_of_pages.times do |i|
      url = (i.zero?)? open('http://www.firstpost.com/category/politics') : open('http://www.firstpost.com/category/politics/page/' + (i + 1).to_s)

      doc = Nokogiri::HTML(url)

      criteria = (i.zero?)? 'div.cat-storieslist div.artCol ul li' : '.col_left div.listlftmn'
      link_criteria = (i.zero?)? 'a' : 'div.FL a'
      date_criteria = (i.zero?)? '.rd_12' : '.bd12nv'

        doc.css(criteria).each do |link|
          article_url = open(link.at_css(link_criteria)['href'])
          article_doc = Nokogiri::HTML(article_url)
          title = article_doc.css('.artTitle').text

          date_unformat = link.css(date_criteria).text
          month = Date::ABBR_MONTHNAMES.index(date_unformat.split[0]).to_s
          day = (date_unformat.split(',')[0].split[1].to_i + 1).to_s
          year = date_unformat.split(', ')[1]
          date = ("#{day}/#{month}/#{year}").to_time

          content = article_doc.css('div.fullCont1').text
          News.create(name: title, description: content, branch: 'Politic', date: date)
        end
    end
  end

  def update_economic(count_of_pages)
    count_of_pages.times do |i|
      url = open('http://www.cnbc.com/economy/?page=' + (i + 1).to_s)

      doc = Nokogiri::HTML(url)

      doc.css('li div.cnbcnewsstory').each do |link|
        article_url = open('http://www.cnbc.com' + link.at_css('.headline a')['href'])
        article_doc = Nokogiri::HTML(article_url)

        title = article_doc.css('.title').text
        # @sub_title = article_doc.css('.article-sub-title').text
        date_unformat = link.css('span.timestamp').text
        month = date_unformat.split('.')[2]
        day = (date_unformat.split('.')[1].to_i + 1).to_s
        year = date_unformat.split('.')[3]
        year.split[1]
        date = ("#{day}/#{month}/#{year}").to_time
        article_doc.css('#result_box')
        content = article_doc.css('#resul').text
        News.create(name: title, description: content, branch: 'Economic', date: date)
      end
    end
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

