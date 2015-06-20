class Nayyar::Township
	attr_reader :data

	@@townships = nil
	@@district_index = {}

	@@attributes = [
		:pcode,
		:name
	]

	def initialize(data)
		@data = data
	end

	# define getters
	@@attributes.each do |attr|
		define_method attr do
			@data[attr]
		end
	end

	# allow the values to be retrieved as an array
	def [](key)
		if @@attributes.include? key
			@data[key]
		elsif :district == key.to_sym
			district
		end
	end

	def district
		Nayyar::District.find_by_pcode(@data[:district])
	end

	class << self
		INDICES = %w(pcode)

		def all
			townships
		end

		def of_district(district)
			state_pcode = district.pcode
			townships = self.townships
			@@district_index[state_pcode].map do |index|
				townships[index]
			end
		end

		def find_by(query)
			key = get_key(query)
			(index = send("#{key}_index".to_sym).index(query[key])) && townships[index]
		end

		def find_by!(query)
			if district = find_by(query)
				district
			else
				key = get_key(query)
				raise Nayyar::TownshipNotFound.new("Cannot find State with given #{key}: #{query[key]}")
			end
		end

		INDICES.each do |index|
	  	define_method("find_by_#{index}") do |query|
	  		find_by(index.to_sym => query)
	  	end
	  	define_method("find_by_#{index}!") do |query|
	  		find_by!(index.to_sym => query)
	  	end
	  end

		protected
			def townships
	    	unless @@townships
					require "yaml"
	    		data = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data', 'townships.yml'))
	    		indices = INDICES.inject({}) { |memo, index| memo.merge index => [] }
	    		i = 0
	    		@@townships= data.map do |township_row|
	    			district_pcode = township_row[:district]
	    			district = new(township_row)
	    			INDICES.each do |index|
	    				indices[index] << district.send(index)
	    			end
	    			@@district_index[district_pcode] ||= []
	    			@@district_index[district_pcode] << i
	    			i += 1
		    		district
	    		end


	    		INDICES.each do |index|
	    			class_variable_set("@@#{index}_index", indices[index])
	    		end
	    	end
	    	@@townships
			end

	    ## define private methods for internal use of indexed array
	    INDICES.each do |index|
		    define_method("#{index}_index") do
			    townships
		    	class_variable_get("@@#{index}_index")
		    end
	    end

	    ## return the index for query given to find_by/find_by! method
		  def get_key(data)
		    keys = data.keys
		    if keys.length != 1 || INDICES.none? { |key| key.to_sym == keys.first.to_sym }
		      raise ArgumentError.new("`find_by` accepts only one of #{INDICES.join(" or ")} as argument. none provided")
		    end
		    keys.first
		  end
	end
end
class Nayyar::TownshipNotFound < StandardError; end;