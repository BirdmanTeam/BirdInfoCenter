require 'open-uri'
class MusicController < ApplicationController
  helper_method :update

  def index
    if (News.count>0)
      @news = News.first
    end




    # url = open('http://www.rollingstone.com/music/news')
    #
    # doc = Nokogiri::HTML(url)
    #
    # doc.css('li.primary-list-item').each do |link|
    #   article_url = open('http://www.rollingstone.com'+link.at_css('.list-item-hd a')['href'])
    #   article_doc = Nokogiri::HTML(article_url)
    #
    #   @title = article_doc.css('.article-title').text
    #   # @sub_title = article_doc.css('.article-sub-title').text
    #
    #   date_unformat = link.css('span.datestamp').text
    #   month = Date::MONTHNAMES.index(date_unformat.split(' ')[0])
    #   day = (date_unformat.split(' ')[1][0..-2].to_i+1).to_s
    #   year = date_unformat.split(' ')[2]
    #   @date = ("#{day}/#{month}/#{year}").to_time
    #
    #   @content = article_doc.css('.article-content p').text
    #   News.create(name: @title, description: @content, branch: "music", date: @date)
    # end
  end

  def update
    url = open('http://www.rollingstone.com/music/news')

    doc = Nokogiri::HTML(url)


    News.delete_all#Delete before record new articles TEST CODE

    doc.css('li.primary-list-item').each do |link|
      article_url = open('http://www.rollingstone.com'+link.at_css('.list-item-hd a')['href'])
      article_doc = Nokogiri::HTML(article_url)

      title = article_doc.css('.article-title').text
      # @sub_title = article_doc.css('.article-sub-title').text

      date_unformat = link.css('span.datestamp').text
      month = Date::MONTHNAMES.index(date_unformat.split(' ')[0])
      day = (date_unformat.split(' ')[1][0..-2].to_i+1).to_s
      year = date_unformat.split(' ')[2]
      date = ("#{day}/#{month}/#{year}").to_time

      content = article_doc.css('.article-content p').text
      News.create(name: title, description: content, branch: "music", date: date)
    end
    redirect_to :back
  end

end