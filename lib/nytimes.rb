class Nyt_article < ActiveRecord::Base
	# belongs_to :feed
	def self.get(feed_id)
		feed = Feed.find_by(id: feed_id)
		# search NEWSWIRE
		# news = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/nyt/all/24.json?limit=10&api-key=99c867716f6d35488c1d0cfd7649bc98:17:65256769")

		# news["results"].each do |new|
		# 	post = {
		# 		feed_id: feed_id, 
		# 		content: new["title"],
		# 		url: new["url"], 
		# 		date: new["published_date"],
		# 		show: true, 
		# 		tag:""}  
		# 	Nyt_article.create(post)
		# end

		# search SEARCH API
		news = HTTParty.get("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=#{feed.search}&api-key=3f3aa28df973fe380ccc48691770dee4:11:65256769")

		news["response"]["docs"].each do |new|
			post = {
				feed_id: feed_id, 
				content: new["headline"]["main"],
				url: new["web_url"], 
				date: new["pub_date"],
				image: "http://www.nytimes.com/#{new["multimedia"][0]["url"]}",
				show: true, 
				tag:""}  
			Nyt_article.create(post)
		end
	end
end

# if multimedia, snippet
# "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all/1.json?api-key=83f1e7b8266adc1daa0d4fbb2fffdcc5:15:65256769"