require 'httparty'
require_relative "./feed"

class Nyt_article < ActiveRecord::Base
	def self.get(feed_id)
		feed = Feed.find_by(id: feed_id)
		news = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/nyt/all/24.json?limit=10&api-key=99c867716f6d35488c1d0cfd7649bc98:17:65256769")

		news["results"].each do |new|
			post = {
				feed_id: feed_id, 
				content: new["title"],
				url: new["url"], 
				date: new["published_date"],
				show: true, 
				tag:""}  
			Nyt_article.create(post)
		end
	end
end

# "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all/1.json?api-key=83f1e7b8266adc1daa0d4fbb2fffdcc5:15:65256769"