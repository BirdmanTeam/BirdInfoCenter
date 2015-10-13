require 'open-uri'

class SportController < ApplicationController

  def index
    url = open('http://www.sportingnews.com/stories?page=1')
    doc = Nokogiri::HTML(url)

    doc.css('div.latest-news-module').each do |link|
      @article_url = link.at_css('li.media a')['href']

      # article_url = open('http://www.cnbc.com'+link.at_css('.headline a')['href'])
      # article_doc = Nokogiri::HTML(article_url)
      #
      # title = article_doc.css('.title').text
      # # @sub_title = article_doc.css('.article-sub-title').text
      # date_unformat = link.css('span.timestamp').text
      # month = Date::ABBR_MONTHNAMES.index(date_unformat.split(' ')[2])
      #
      # day = (date_unformat.split(' ')[1].to_i+1).to_s
      # year = date_unformat.split(' ')[3]
      # date = ("#{day}/#{month}/#{year}").to_time
      #
      # content = article_doc.css('.group p').text
      # News.create(name: title, description: content, branch: 'Economic', date: date)
      break
    end
  end

end
