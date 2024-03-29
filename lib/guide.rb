
class Guide

	@@actions = ['list', 'find', 'add', 'quit']

	def initialize(path=nil)
		# locate the restaurant text file at path
		Restaurant.filepath = path

		if Restaurant.file_usable?
			puts "Found restaurant file."
		elsif Restaurant.create_file
			puts "Created restaurant file."
		else
			# exit if create fails
			puts "Exiting.\n\n"
			exit!
		end
	end

	def launch!
		introduction
			# action loop
			#   what do you want to?
		result = nil
		until result == :quit
			print "< "
			args = gets.chomp.downcase.strip.split(' ')
			action = args.shift
			result = do_action(action, args)
		end
		conclusion
	end

	def do_action(action, args)
		case action
		when 'list'
			list(args)
		when 'add'
			add
		when 'find'
			keyword = args.shift
			find(keyword)
		when 'quit'
			return :quit
		else
			puts "\nI don't understand that command\n"
			puts "The commands available are #{@@actions}"
		end
	end

	def list(args=[])
		sort_order = args.shift
		sort_order = args.shift if sort_order == 'by'
		sort_order = "name" unless ["name", "cuisine", "price"].include?(sort_order)

		output_action_header("Listing restaurants")
		restaurants = Restaurant.saved_restaurants

		restaurants.sort! do |r1, r2|
			case sort_order
			when "name"
				r1.name.downcase <=> r2.name.downcase
			when "cuisine"
				r1.cuisine.downcase <=> r2.cuisine.downcase
			when "price"
				r1.price.to_i <=> r2.price.to_i
			end
		end
		output_restaurant_table(restaurants)
		puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
	end

	def add
		output_action_header("Add restaurant")

		args = {}
		restaurant = Restaurant.new
		
		print "Restaurant name: "
		args[:name] = gets.chomp.strip.titleize
		print "Restaurant cuisine: "
		args[:cuisine] = gets.chomp.strip.titleize
		print "Average meal price: "
		args[:price] = gets.chomp.strip

		restaurant = Restaurant.new(args)		

		if restaurant.save
			puts "Restaurant added"
		else
			puts "Save Error: restaurant not added"
		end
	end

	def find(keyword="")
		output_action_header("Find a restaurant")

		if keyword
			restaurants = Restaurant.saved_restaurants
			found = restaurants.select do |rest|
				rest.name.downcase.include?(keyword.downcase) ||
				rest.cuisine.downcase.include?(keyword.downcase) ||
				rest.price.to_i <= keyword.to_i
			end
			output_restaurant_table(found)
		else
			puts "Find using a key phrase to search the restaurant list"
			puts "Examples: 'find pizza', 'find Mexican', 'find mex'\n\n"
		end
	end

	def introduction
		puts "\n\n<<< Welcome to the Food Finder >>> \n\n"
		puts "This is an interactive guide to help you find the food you crave.\n\n"
		puts "The commands available are #{@@actions}"
	end

	def conclusion
		puts "\n<<< Goodbye and Bon Appetit! >>>\n\n\n"
	end



	private

	def output_action_header(text)
		puts "\n#{text.center(60).upcase}\n\n"
	end

	def output_restaurant_table(restaurants=[])
		print " " + "Name".ljust(30)
		print " " + "Cuisine".ljust(20)
		print " " + "Price".rjust(6) + "\n"
		puts	"-" * 60

		restaurants.each do |rest|
			line =	" " << rest.name.ljust(30)
			line << " " + rest.cuisine.ljust(20)
			line << " " + rest.price.rjust(6)
			puts line
		end

		puts "No listings found" if restaurants.empty?
		puts "-" * 60

	end


end