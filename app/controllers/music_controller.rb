require 'open-uri'
class MusicController < ApplicationController

  def index
    url = open('http://www.rollingstone.com/music/news')

    doc = Nokogiri::HTML(url)

    doc.css('li.primary-list-item').each do |link|
      @date = link.css('h3 a').text
    end

  end

end