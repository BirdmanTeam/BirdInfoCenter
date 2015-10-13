require 'weather_api'

class NewsController < ApplicationController
  include WeatherApi

  def index
    @weather_api = weather_api
    @news = News.all
  end

  def parse_news
    update_music

    redirect_to :back
  end

  private

  def update_music
    count_of_pages = 5
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
      i+=1
    end
  end

  def update_sport

  end

  def update_economic

  end

  def update_politic

  end

end

