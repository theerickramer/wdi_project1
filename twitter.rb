require 'pry'
require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "AQJ8SKdgZC1z60NNHbrddlpuA"
  config.consumer_secret     = "lSyk642bqruQNLwPyi5AbkE8kEJRwIAogS4CGIojL3jDVmfXMN"
  # config.access_token        = "YOUR_ACCESS_TOKEN"
  # config.access_token_secret = "YOUR_ACCESS_SECRET"
end

tag = "death"

tweets = client.search("\##{tag}", :result_type => "recent").take(10).collect do |tweet| 
	"#{tweet.user.screen_name}: #{tweet.text}"
end

binding.pry