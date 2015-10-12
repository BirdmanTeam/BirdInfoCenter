require 'open-uri'

module WeatherApi
  def weather_api
    link = 'http://weather.yahooapis.com/forecastrss?w=922221&u=c'
    data = Nokogiri::XML(open(link))
    @weather_block = '<div class = "weather-container">'
    temp_date = data.xpath('//item//yweather:forecast')[0]['date'].split(' ')
    temp_date.pop
    temp_date[0], temp_date[1] = temp_date[1], temp_date[0]
    @weather_block += '<h3 class = "weather-date">' + temp_date.join(', ') +'</h3>'
    @weather_block += '<h2 class = "weather-current">'
    @weather_block += data.xpath('//item//yweather:condition')[0]['temp'] +' &deg;C</h2>'
    @weather_block += '<i class="wi ' + Constant.weathers[data.xpath('//item//yweather:forecast')[0]['code']] + '"></i>'
    @weather_block += '<h5 class = "weather-type">' + data.xpath('//item//yweather:forecast')[0]['text'] + '</h5>'
    @weather_block += '<h5 class = "weather-temperature"> Day: ' + data.xpath('//item//yweather:forecast')[0]['high']
    @weather_block += ' &deg;C.</br> Night: ' + data.xpath('//item//yweather:forecast')[0]['low'] + ' &deg;C.</h5>'
    @weather_block += '</div>'
  end
end