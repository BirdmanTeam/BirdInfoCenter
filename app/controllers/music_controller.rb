class MusicController < ApplicationController

  def index
    news_tmp_file = open('http://www.rollingstone.com/music/news')

    # Parse the contents of the temporary file as HTML
    doc = Nokogiri::HTML(news_tmp_file)

    @title
    # Define the css selectors to be used for extractions, most

    #article_css_class         =".esc-layout-article-cell"
    article_css_class         =".primary-list-item page-lead"
    article_date_css_class  ="span.datestamp"
    #article_header_css_class  ="span.titletext"
    article_header_css_class  =".list-item-hd"
    article_summary_css_class =".esc-lead-snippet-wrapper"

    # extract all the articles
    articles = doc.css(article_css_class)

    #html output
    html = ""

    #extract the title from the articles
    articles.each do |article|
      @title = article.css(article_header_css_class)

    end

  end
end