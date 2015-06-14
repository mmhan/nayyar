class Nayyar::State
	attr_reader :data

	attributes = [
		:pcode,
		:iso,
		:name
	]
	attributes.each do |attr|
		define_method attr do
			@data[attr]
		end
	end

	def initialize(data)
		@data = data
	end

	def [](key)
		@data[key]
	end
end

