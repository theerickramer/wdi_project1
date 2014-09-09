ActiveRecord::Base.establish_connection({
	adapter: "postgresql",
	host: "ec2-23-21-101-129.compute-1.amazonaws.com",
	username: "puorcinlngftfv",
	database: "d3oh2hd0hvidm3"
	})

ActiveRecord::Base.logger = Logger.new(STDOUT)