class Forecast < ActiveRecord::Base
	belongs_to :feed
	def self.get(feed_id)
		feed = Feed.find_by(id: feed_id)
		state = feed.search.split(",")
		if state[1]
			state = state[1].strip
		else
			state = ''
		end
		city = feed.search.split(",")[0].split(" ").join("_")
		weather = HTTParty.get("http://api.wunderground.com/api/b874e78ef7f5e7ae/forecast10day/q/#{state}/#{city}.json")

		if weather["forecast"]
			weather["forecast"]["simpleforecast"]["forecastday"].each do |day|
					forecast = {
						feed_id: feed_id, 
						content: "#{day["date"]["weekday"]} #{day["date"]["monthname"]} #{day["date"]["day"]} #{day["date"]["year"]} - HI: #{day["high"]["fahrenheit"]}/LO: #{day["low"]["fahrenheit"]}, #{day["conditions"]}", 
						date: day["date"]["pretty"],
						url: "http://www.wunderground.com", 
						image: day["icon_url"], 
						show: true, 
						tag: ""}
					Forecast.create(forecast)
			end
		else
			forecast = {
				feed_id: feed_id, 
				content: "#{feed.search} not found",
				show: true, 
				tag: ""}
			Forecast.create(forecast)
		end
	end
end