class Feed < ActiveRecord::Base
	has_many :tweets, dependent: :destroy
	has_many :weather_forecasts, dependent: :destroy
	has_many :nyt_articles, dependent: :destroy
end