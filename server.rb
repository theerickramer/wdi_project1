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
	if params[:kind] == "tweet"
		Feed.create({kind: "tweet", search: params[:search]})
	elsif params[:kind] == "weather_forecast"
		Feed.create({kind: "weather_forecast", search: params[:search]})
	elsif params[:kind] == "nyt_article"
		Feed.create({kind: "nyt_article", search: params[:search]})
	end
	feed = Feed.last
	kind = params[:kind].capitalize.constantize #converts string to class
	kind.get(feed.id)
	redirect("/")
end

get("/feed/:name") do

end

put("/feed/:post/:tag") do

end

delete("/feed/:post") do 

end