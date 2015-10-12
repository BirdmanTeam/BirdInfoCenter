require 'open-uri'

class MusicController < ApplicationController

  def index
    if (News.count>0)
      @news = News.first
    end
  end

end