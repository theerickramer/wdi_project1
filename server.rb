require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative "./lib/connection"
require_relative "./lib/feed"
require_relative "./lib/nytimes"
require_relative "./lib/weather"
require_relative "./lib/twitter"

set :server, 'webrick' # resolves http conflict between sinatra & twitter gem

after do 
	ActiveRecord::Base.connection.close
end

# binding.pry
def weather_update
	weather_feeds = Feed.where(kind: "weather_forecast")
	last_weather = weather_feeds.last
	feed = Feed.create({kind: "weather_forecast", search: last_weather.search})
	Weather_forecast.get(feed.id)
end

get("/") do
	feeds = Feed.all()
	erb(:index, { locals: {feeds: feeds } })
end

post("/feed/add") do
	case params[:kind]
	when "tweet"
		Feed.create({kind: "tweet", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %l:%M:%S%p")})
	when "weather_forecast"
		Feed.create({kind: "weather_forecast", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %l:%M:%S%p")})
	when "nyt_article"
		Feed.create({kind: "nyt_article", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %l:%M:%S%p")})
	end
	feed = Feed.last
	kind = params[:kind].capitalize.constantize # converts string to class
	kind.get(feed.id)
	redirect("/")
end

get("/feed/search") do
	feed = Feed.find_by(id: params[:feed_id])
	kind = feed.kind.capitalize.constantize
	search = params[:search]
	posts = kind.where(tag: search)
	erb(:search, { locals: { posts: posts, search: search } })
end

get("/feed/:name") do
	feeds = Feed.where(kind: params[:name])
	erb(:feed, { locals: { feeds: feeds } })
end

put("/feed") do
	feed = Feed.find_by(id: params[:feed_id]) 
	kind = feed.kind.capitalize.constantize
	post = kind.find_by(id: params[:id])     
	post.update(:tag => params[:tag])
	redirect request.referrer
end

delete("/feed/post") do
	feed = Feed.find_by(id: params[:feed_id]) 
	kind = feed.kind.capitalize.constantize
	post = kind.find_by(id: params[:id])   
	post.destroy
	redirect request.referrer 
end

delete("/feed") do
	feed = Feed.find_by(id: params[:feed_id]) 
	feed.destroy
	redirect request.referrer 
end