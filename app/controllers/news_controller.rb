class NewsController < ApplicationController
  include NewsHelper

  def parse_news

    update_sport(3)
    update_music(3)
    update_politic(3)
    update_economics(3)

    redirect_to root_path
  end

  def show
    @weather_api = weather_api(922221)
    @article = News.find(params[:id])
    @news = News.all
    @popular = @news.where(:popular => true)
  end

  def popularization
    @article = News.find(params[:id])
    if request.post?
      @article.popular = true
    elsif request.delete?
      @article.popular = false
    end
    @article.save

    @@current_controller = params[:type] unless params[:type] == 'news'
    puts 'c: ' + @@current_controller
    @news = (@@current_controller == 'home')? News.all.where(:popular => true) : News.all.where(:branch => @@current_controller, :popular => true)

    respond_to do |format|
      format.js
    end
  end
  private


  def update_music(count_of_pages)
    news_array = Array.new

    is_db_empty = News.where(:branch => 'Music').empty?
    fresh_date = (is_db_empty)? nil : News.where(:branch => 'Music').order(:date).last.date
    News.where(:date => fresh_date, :branch => 'Music').destroy_all unless is_db_empty

    catch :up_to_date do
      count_of_pages.times do |i|
        url = open('http://www.rollingstone.com/music/news?page=' + (i + 1).to_s)

        doc = Nokogiri::HTML(url)

        doc.css('li.primary-list-item').each do |link|
          begin
            article_url = open('http://www.rollingstone.com' + link.at_css('.list-item-hd a')['href'])
            article_doc = Nokogiri::HTML(article_url)

            if article_doc.at_css('.article-img-holder img')
              photo = article_doc.at_css('.article-img-holder img').attr('src')
              video = 'none'
            elsif article_doc.at_css('.article-img-holder iframe')
              video = article_doc.at_css('.article-img-holder iframe').attr('src')
              photo ='none'
            else
              photo = 'none'
              video = 'none'
            end

            title = article_doc.css('.article-title').text
            date_unformat = link.css('span.datestamp').text
            month = Date::MONTHNAMES.index(date_unformat.split[0])
            day = (date_unformat.split[1][0..-2].to_i + 1).to_s
            year = date_unformat.split[2]
            date = ("#{day}/#{month}/#{year}").to_time

            content = article_doc.css('.article-content p').text
            raise Exception if content.length == 0

            throw :up_to_date if date < fresh_date unless is_db_empty

            news_array << { name: title, description: content, branch: 'Music', date: date, photo: photo, video: video }
          rescue Exception
          end
        end
      end
    end
    News.create(news_array)
  end

  def update_politic(count_of_pages)
    news_array = Array.new

    is_db_empty = News.where(:branch => 'Politic').empty?
    fresh_date = (is_db_empty)? nil : News.where(:branch => 'Politic').order(:date).last.date
    News.where(:date => fresh_date, :branch => 'Politic').destroy_all unless is_db_empty

    catch :up_to_date do
      count_of_pages.times do |i|
        url = open('http://www.firstpost.com/category/politics/page/' + (i + 1).to_s)

        doc = Nokogiri::HTML(url)

        criteria = (i.zero?)? 'div.cat-storieslist div.artCol ul li' : '.col_left div.listlftmn'
        link_criteria = (i.zero?)? 'a' : 'div.FL a'
        date_criteria = (i.zero?)? '.rd_12' : '.bd12nv'

        doc.css(criteria).each do |link|
          begin
            article_url = open(link.at_css(link_criteria)['href'])
            article_doc = Nokogiri::HTML(article_url)

            if article_doc.at_css('.wp-caption img')
              photo = article_doc.at_css('.wp-caption img').attr('data-original')
              video = 'none'
              #This code for parse video if it exist
              #elsif article_doc.at_css('.article-img-holder iframe')
              #   @source = article_doc.at_css('.article-img-holder iframe').attr('src')
            else
              photo = 'none'
              video = 'none'
            end

            title = article_doc.css('.artTitle').text
            date_unformat = link.css(date_criteria).text
            month = Date::ABBR_MONTHNAMES.index(date_unformat.split[0]).to_s
            day = (date_unformat.split(',')[0].split[1].to_i + 1).to_s
            year = date_unformat.split(', ')[1]
            date = ("#{day}/#{month}/#{year}").to_time

            content = article_doc.css('div.fullCont1').text
            raise Exception if content.length == 0

            throw :up_to_date if date < fresh_date unless is_db_empty

            news_array << { name: title, description: content, branch: 'Politic', date: date, photo: photo, video: video }
          rescue Exception
          end
        end
      end
    end
    News.create(news_array)
  end

  def update_economics(count_of_pages)
    news_array = Array.new

    is_db_empty = News.where(:branch => 'Economics').empty?
    fresh_date = (is_db_empty)? nil : News.where(:branch => 'Economics').order(:date).last.date
    News.where(:date => fresh_date, :branch => 'Economics').destroy_all unless is_db_empty

    catch :up_to_date do
      count_of_pages.times do |i|
        url = open('http://www.cnbc.com/economy/?page=' + (i + 1).to_s)

        doc = Nokogiri::HTML(url)

        doc.css('div.cnbcnewsstory').each do |link|
          begin
            article_url = open('http://www.cnbc.com' + link.at_css('.headline a')['href'])
            article_doc = Nokogiri::HTML(article_url)

            if article_doc.css('.embed-container iframe')
              #Paste iframe in video
              video = 'none'
              photo = 'none'
            elsif article_doc.css('.embed-container img')
              photo = article_doc.css('.embed-container img')[0]['src']
              video = 'none'
            else
              photo = 'none'
              video = 'none'
            end

            title = article_doc.css('div.story-top .title').text
            date = DateTime.parse(article_doc.at_css('div.story-top time')['datetime']).beginning_of_day
            content = article_doc.css('#article_body p').text
            raise Exception if content.length == 0

            throw :up_to_date if date < fresh_date unless is_db_empty

            news_array << { name: title, description: content, branch: 'Economics', date: date, photo: photo, video: video }
          rescue Exception
          end
        end
      end
    end
    News.create(news_array)
  end

  def update_sport(count_of_pages)
    conditions = %w(/gallery/ /picture/ /video/ /live/)
    news_array = Array.new

    is_db_empty = News.where(:branch => 'Sport').empty?
    fresh_date = (is_db_empty)? nil : News.where(:branch => 'Sport').order(:date).last.date
    News.where(:date => fresh_date, :branch => 'Sport').destroy_all unless is_db_empty

    catch :up_to_date do
      count_of_pages.times do |i|
        url = open('http://www.theguardian.com/sport?page=' + (i + 1).to_s)

        doc = Nokogiri::HTML(url)

        doc.css('div.fc-item__container').each do |link|
          begin
            link_criteria = link.at_css('div.fc-item__content a')['href']
            next unless check_links(link_criteria, conditions)

            article_url = open(link_criteria)
            article_doc = Nokogiri::HTML(article_url)

            if article_doc.at_css('.article__img-container img')
              photo = article_doc.at_css('.article__img-container img').attr('src')
              video = 'none'
              #This code for parse video if it exist
              # elsif article_doc.at_css('.article-img-holder iframe')
              #   video = article_doc.at_css('.article-img-holder iframe').attr('src')
              #   photo ='none'
            else
              photo = 'none'
              video = 'none'
            end

            title = link.css('span.js-headline-text').text

            date = DateTime.parse(article_doc.at_css('div.content__meta-container .content__dateline time')['datetime']).beginning_of_day
            content = article_doc.css('article.content div.content__main div.content__article-body p').text
            raise Exception if content.length == 0

            throw :up_to_date if date < fresh_date unless is_db_empty

            news_array << { name: title, description: content, branch: 'Sport', date: date, photo: photo, video: video }
          rescue Exception
          end
        end
      end
    end
    News.create(news_array)
  end

  def set_news
    @article = News.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:name, :description, :branch, :popular, :date)
  end

end

