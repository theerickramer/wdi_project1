class Tweet < ActiveRecord::Base
	belongs_to :feed 
	def self.get(feed_id)
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = "AQJ8SKdgZC1z60NNHbrddlpuA"
		  config.consumer_secret     = "lSyk642bqruQNLwPyi5AbkE8kEJRwIAogS4CGIojL3jDVmfXMN"
		  # config.access_token        = "YOUR_ACCESS_TOKEN"
		  # config.access_token_secret = "YOUR_ACCESS_SECRET"
		end

		feed = Feed.find_by(id: feed_id)

		hashtag = feed.search
		tweets = client.search("\##{hashtag}").take(10).collect do |tweet|  
			post = {
				content: "@#{tweet.user.screen_name}: #{tweet.text}", 
				tag: "", 
				date: tweet.created_at, 
				url: "#{tweet.url}", 
				feed_id: feed_id, 
				show: true
			}
			Tweet.create(post)
		end
	end
end