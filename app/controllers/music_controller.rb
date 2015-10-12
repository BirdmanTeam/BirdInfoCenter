require 'open-uri'
class MusicController < ApplicationController
  helper_method :update

  def index
    url = open('http://www.rollingstone.com/music/news')

    doc = Nokogiri::HTML(url)

    doc.css('li.primary-list-item').each do |link|
      @link_url = link.css('div.list-item-hd a[href]').text
      @date_unformat = link.css('span.datestamp').text
      month = Date::MONTHNAMES.index(@date_unformat.split(' ')[0])
      day = @date_unformat.split(' ')[1][0..-2]
      year = @date_unformat.split(' ')[2]
      @date = ("#{day}/#{month}/#{year}").to_time
    end
  end

  def update
    url = open('http://www.rollingstone.com/music/news')

    doc = Nokogiri::HTML(url)


    doc.css('li.primary-list-item').each do |link|
      @link_url = link.css('.list-item-hd href')


      # News.create()
    end
    redirect_to music_path
  end

end