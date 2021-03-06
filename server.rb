########## CONFIG ##########
require 'uri'
require 'pry'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative "./lib/connection"
require_relative "./lib/feed"
require_relative "./lib/nytimes"
require_relative "./lib/weather"
require_relative "./lib/twitter"
require_relative "./lib/soundcloud"

set :server, 'webrick' # resolves http conflict between sinatra & twitter gem

after do 
	ActiveRecord::Base.connection.close
end

########## METHODS ##########

def weather_update_daily	
	weather_feeds = Feed.where(kind: "forecast")
	last_weather = weather_feeds.last
	if last_weather
		last_get = last_weather.date.split("/")[1] # get last weather feed day
		if Time.now.strftime("%-d") > last_get # compare to last weather feed day
		# last_get = last_weather.date.split(":")[0].split(" ")[1] # get last weather feed hour
		# if Time.now.strftime("%-l") > last_get # compare to last weather feed hour
			feed = Feed.create({kind: "forecast", search: last_weather.search, date: Time.now.strftime("%-m/%-d/%y %-l:%M:%S%p")})
			Forecast.get(feed.id)
		end
	end
end

def find_post(feed_id, id)
	feed = Feed.find_by(id: feed_id) 
	kind = feed.kind.capitalize.constantize
	post = kind.find_by(id: id) 
end

########## ROUTES ##########

get("/") do
	feeds = Feed.all()
	
	weather_update_daily()
	weather_feeds = Feed.where(kind: "forecast")
	if weather_feeds.length > 1
		weather_feeds.first.destroy
	end
	erb(:index, { locals: {feeds: feeds } })
end

# get("/feed/search") do
# 	feed = Feed.find_by(id: params[:feed_id])
# 	kind = feed.kind.capitalize.constantize
# 	search = params[:search]
# 	posts = kind.where(tag: search)
# 	erb(:search, { locals: { posts: posts, search: search } })
# end

get("/feed/search") do
	tagged = []
	search = params[:search]
	tweets = Tweet.where(tag: search)
	tagged << tweets
	forecasts = Forecast.where(tag: search)
	tagged << forecasts
	articles = Article.where(tag: search)
	tagged << articles
	sounds = Sound.where(tag: search)
	tagged << sounds
	erb(:search, { locals: { tagged: tagged, search: search } })
end

get("/feed/:name") do	
	feeds = Feed.where(kind: params[:name])
	page = params[:page].to_i
	erb(:feed, { locals: { feeds: feeds, page: page } })
end

get("/as") do
	content_type :json
	feeds = Feed.where(kind: params[:feed])
	request = []
	feeds.each do |feed|
		kind = feed.kind.capitalize.constantize
		posts = kind.all
		posts.each do |post|
			record = {
				url: post.url,
				content: post.content,
				date: post.date
			}
			request << record
		end
	end
	request.to_json
end
	
post("/feed/add") do
	case params[:kind]
	when "tweet"
		Feed.create({kind: "tweet", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %-l:%M:%S%p")})
	when "forecast"
		Feed.create({kind: "forecast", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %-l:%M:%S%p")})
	when "article"
		Feed.create({kind: "article", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %-l:%M:%S%p")})
	when "sound"
		Feed.create({kind: "sound", search: params[:search], date: Time.now.strftime("%-m/%-d/%y %-l:%M:%S%p")})
	end
	feed = Feed.last
	kind = params[:kind].capitalize.constantize # converts string to class
	kind.get(feed.id)
	redirect("/")
end

put("/feed") do
	post = find_post(params[:feed_id], params[:id])   
	post.update(:tag => params[:tag])
	redirect request.referrer
end

delete("/feed/post") do
	post = find_post(params[:feed_id], params[:id])  
	post.destroy
	redirect request.referrer 
end

delete("/feed") do
	feed = Feed.find_by(id: params[:feed_id]) 
	feed.destroy
	redirect request.referrer 
end