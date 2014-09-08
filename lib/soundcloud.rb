class Sound < ActiveRecord::Base
	belongs_to :feed

	def self.get(feed_id)
		client = SoundCloud.new(:client_id => '9eb06ad38e248d5444a8f7b12669840a')

		feed = Feed.find_by(id: feed_id)
		search = feed.search

		tracks = client.get('/tracks', :limit => 10, :q => '#{search}') 

		tracks.each do |track|
	  		post = {
	  			url: track.permalink_url,
				content: "#{track.user.username}: #{track.title}",
				image: track.avatar_url,
				feed_id: feed_id,
				tag: "", 
				show: true
			}
			Sound.create(post)
		end
	end
end

# get 10 hottest tracks
# tracks = client.get('/tracks', :limit => 10, :order => 'hotness')
# print each link