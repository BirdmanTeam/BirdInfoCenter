class NewsController < ApplicationController
  include NewsHelper

  def index
    @weather_api = weather_api
    @news = News.paginate(:page => params[:page], :per_page => 10).order(:date).reverse_order
  end

  def parse_news
    News.delete_all

    update_music(1)
    update_economic(1)
    update_politic(1)
    update_sport(1)

    redirect_to root_path
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

        if article_doc.at_css('.article-img-holder img')
          source = article_doc.at_css('.article-img-holder img').attr('src')
        elsif article_doc.at_css('.article-img-holder iframe')
          source = article_doc.at_css('.article-img-holder iframe').attr('src')
        else
          source = 'http://www.gobizkorea.com/catalog/images/common/no_article1.gif'
        end

        title = article_doc.css('.article-title').text
        date_unformat = link.css('span.datestamp').text
        month = Date::MONTHNAMES.index(date_unformat.split[0])
        day = (date_unformat.split[1][0..-2].to_i + 1).to_s
        year = date_unformat.split[2]
        date = ("#{day}/#{month}/#{year}").to_time

        content = article_doc.css('.article-content p').text
        News.create(name: title, description: content, branch: 'Music', date: date, source: source)
      end
    end
  end

  def update_politic(count_of_pages)
    count_of_pages.times do |i|
      url = open('http://www.firstpost.com/category/politics/page/' + (i + 1).to_s)

      doc = Nokogiri::HTML(url)

      criteria = (i.zero?)? 'div.cat-storieslist div.artCol ul li' : '.col_left div.listlftmn'
      link_criteria = (i.zero?)? 'a' : 'div.FL a'
      date_criteria = (i.zero?)? '.rd_12' : '.bd12nv'

        doc.css(criteria).each do |link|
          article_url = open(link.at_css(link_criteria)['href'])
          article_doc = Nokogiri::HTML(article_url)

          if article_doc.at_css('.wp-caption img')
            source = article_doc.at_css('.wp-caption img').attr('data-original')
            #elsif article_doc.at_css('.article-img-holder iframe')
            #   @source = article_doc.at_css('.article-img-holder iframe').attr('src')
          else
            source = 'http://www.gobizkorea.com/catalog/images/common/no_article1.gif'
          end

          title = article_doc.css('.artTitle').text
          date_unformat = link.css(date_criteria).text
          month = Date::ABBR_MONTHNAMES.index(date_unformat.split[0]).to_s
          day = (date_unformat.split(',')[0].split[1].to_i + 1).to_s
          year = date_unformat.split(', ')[1]
          date = ("#{day}/#{month}/#{year}").to_time

          content = article_doc.css('div.fullCont1').text
          News.create(name: title, description: content, branch: 'Politic', date: date, source: source)
        end
    end
  end

  def update_economic(count_of_pages)
    count_of_pages.times do |i|
      url = open('http://www.cnbc.com/economy/?page=' + (i + 1).to_s)

      doc = Nokogiri::HTML(url)

      doc.css('div.cnbcnewsstory').each do |link|
        article_url = open('http://www.cnbc.com' + link.at_css('.headline a')['href'])
        article_doc = Nokogiri::HTML(article_url)

        source = 'http://www.gobizkorea.com/catalog/images/common/no_article1.gif'

        title = article_doc.css('div.story-top .title').text
        date = DateTime.parse(article_doc.at_css('div.story-top time')['datetime']).beginning_of_day
        content = article_doc.css('#article_body p').text
        News.create(name: title, description: content, branch: 'Economic', date: date, source: source)
      end
    end
  end

  def update_sport(count_of_pages)
    conditions = %w(/gallery/ /picture/ /video/ /live/)

    count_of_pages.times do |i|
      url = open('http://www.theguardian.com/sport?page=' + (i + 1).to_s)

      doc = Nokogiri::HTML(url)

      doc.css('div.fc-item__container').each do |link|

        link_criteria = link.at_css('div.fc-item__content a')['href']
        next unless check_links(link_criteria, conditions)

        article_url = open(link_criteria)
        article_doc = Nokogiri::HTML(article_url)

        source = 'http://www.gobizkorea.com/catalog/images/common/no_article1.gif'

        title = link.css('span.js-headline-text').text
        date = DateTime.parse(article_doc.at_css('div.content__meta-container .content__dateline time')['datetime']).beginning_of_day
        content = article_doc.css('article.content div.content__main div.content__article-body p').text
        News.create(name: title, description: content, branch: 'Sport', date: date, source: source)
      end
    end
  end

  def set_news
    @article = News.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:name, :description, :branch, :popular, :date)
  end

end

