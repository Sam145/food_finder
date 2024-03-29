class Restaurant

	@@filepath = nil

	attr_accessor :name, :cuisine, :price

	def self.filepath=(path = nil)
		@@filepath = File.join(APP_ROOT, path)
	end

	def self.file_exists?
		if @@filepath && File.exists?(@@filepath)
			return true
		else
			return false
		end
	end

	def self.file_usable?
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true
	end

	def self.create_file
		File.open(@@filepath, 'w') unless file_exists?
		return file_usable?
	end

	def self.saved_restaurants
		restaurants = []
		args = {}
		
		if file_usable?
			file = File.open(@@filepath, 'r')
			file.each_line do |line|
				args[:name], args[:cuisine], args[:price] = line.chomp.split("\t")
				restaurants << Restaurant.new(args)
			end
			file.close
		end

		return restaurants
	end

	def self.search(user_search)
		File.open(@@filepath, 'r') do |file|
			file.readlines.grep(/user_search/).each { |f| print f }
		end
	end

	def initialize(args={})
		@name 		= args[:name] 		|| ""
		@cuisine	= args[:cuisine]	|| ""
		@price 		= args[:price] 		|| ""
	end

	def save
		return false unless Restaurant.file_usable?
		File.open(@@filepath, 'a') do |file|
			file.puts "#{[@name, @cuisine, @price].join("\t")}\n" 
		end
		return true
	end


end