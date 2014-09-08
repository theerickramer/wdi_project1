class Feed < ActiveRecord::Base
	has_many :tweets, dependent: :destroy
	has_many :forecasts, dependent: :destroy
	has_many :articles, dependent: :destroy
	has_many :sounds, dependent: :destroy
end