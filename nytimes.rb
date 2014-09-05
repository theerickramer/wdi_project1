require 'httparty'

news = HTTParty.get("http://api.nytimes.com/svc/news/v3/content/nyt/all/24.json?limit=10&api-key=99c867716f6d35488c1d0cfd7649bc98:17:65256769")

# "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all/1.json?api-key=99c867716f6d35488c1d0cfd7649bc98:17:65256769"

news.each do |new|
	news_post = { headline: new["results"]["title"],
	link: new["results"]["url"] }
end