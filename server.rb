require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'active_record'
require_relative "./lib/connection"
require_relative "./lib/feed"
require_relative "./lib/nytimes"
require_relative "./lib/weather"
require_relative "./lib/twitter"

set :server, 'webrick'

after do 
	ActiveRecord::Base.connection.close
end

get("/") do
	feeds = Feed.all()
	erb(:index, { locals: {feeds: feeds } })
end

post("/feed/add") do
	case params[:kind]
	when "tweet"
		Feed.create({kind: "tweet", search: params[:search]})
	when "weather_forecast"
		Feed.create({kind: "weather_forecast", search: params[:search]})
	when "nyt_article"
		Feed.create({kind: "nyt_article", search: params[:search]})
	end
	feed = Feed.last
	kind = params[:kind].capitalize.constantize #converts string to class
	kind.get(feed.id)
	redirect("/")
end

get("/feed/:name") do
	feeds = Feed.where(kind: params[:name])
	erb(:feed, { locals: { feeds: feeds } })
end

put("/feed") do
	feed = Feed.find_by(id: params[:feed_id]) 
	kind = feed.kind.capitalize.constantize
	post = Weather_forecast.find_by(feed_id: feed.id)   
	post.update(:tag => params[:tag])
	redirect request.referrer
end

delete("/feed/post") do
	feed = Feed.find_by(id: params[:feed_id]) 
	kind = feed.kind.capitalize.constantize
	post = Weather_forecast.find_by(feed_id: feed.id)   
	post.destroy
	redirect request.referrer 
end

delete("/feed") do
	feed = Feed.find_by(id: params[:feed_id]) 
	feed.destroy
	redirect request.referrer 
end