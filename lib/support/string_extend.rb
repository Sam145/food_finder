class String

	def titleize
		self.split(" ").map { |str| str.capitalize }.join(" ")
	end

end