require 'httparty'
require 'pry'

weather = HTTParty.get("http://api.wunderground.com/api/b874e78ef7f5e7ae/forecast10day/q/CA/San_Francisco.json")

tenday = []

weather["forecast"]["simpleforecast"]["forecastday"].each do |day|
	forecast = "#{day["date"]["weekday"]} #{day["date"]["monthname"]} #{day["date"]["day"]} #{day["date"]["year"]} - HIGH: #{day["high"]["fahrenheit"]} LOW: #{day["low"]["fahrenheit"]} CONDITIONS: #{day["date"]["conditions"]}"
	tenday << forecast
end

binding.pry

# day["date"]["icon_url"]