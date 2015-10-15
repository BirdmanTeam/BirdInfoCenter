class TestParseNewsController < ApplicationController
  def index

    i=2
    url = open('http://www.firstpost.com/category/politics/page/' + (i + 1).to_s)

    doc = Nokogiri::HTML(url)

    criteria = (i.zero?)? 'div.cat-storieslist div.artCol ul li' : '.col_left div.listlftmn'
    link_criteria = (i.zero?)? 'a' : 'div.FL a'
    date_criteria = (i.zero?)? '.rd_12' : '.bd12nv'

    doc.css(criteria).each do |link|
      article_url = open(link.at_css(link_criteria)['href'])
      article_doc = Nokogiri::HTML(article_url)

      if article_doc.at_css('.wp-caption img')
        @source = article_doc.at_css('.wp-caption img').attr('data-original')
      #elsif article_doc.at_css('.article-img-holder iframe')
      #   @source = article_doc.at_css('.article-img-holder iframe').attr('src')
      else
        @source = 'http://www.gobizkorea.com/catalog/images/common/no_article1.gif'
      end

      @title = article_doc.css('.artTitle').text
      date_unformat = link.css(date_criteria).text
      month = Date::ABBR_MONTHNAMES.index(date_unformat.split[0]).to_s
      day = (date_unformat.split(',')[0].split[1].to_i + 1).to_s
      year = date_unformat.split(', ')[1]
      date = ("#{day}/#{month}/#{year}").to_time

      content = article_doc.css('div.fullCont1').text
      # News.create(name: title, description: content, branch: 'Politic', date: date, source: source)
      break
    end

  end
end
