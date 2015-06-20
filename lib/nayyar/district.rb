class Nayyar::District
	attr_reader :data

	@@districts = nil
	@@state_index = {}

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
		elsif :state == key.to_sym
			state
		end
	end

	def state
		Nayyar::State.find_by_pcode(@data[:state])
	end

	class << self
		INDICES = %w(pcode)

		def all
			self.districts
		end

		def of_state(state)
			state_pcode = state.pcode
			districts = self.districts
			@@state_index[state_pcode].map do |index|
				districts[index]
			end
		end

		def find_by(query)
			key = get_key(query)
			(index = send("#{key}_index".to_sym).index(query[key])) && districts[index]
		end

		def find_by!(query)
			if district = find_by(query)
				district
			else
				key = get_key(query)
				raise Nayyar::DistrictNotFound.new("Cannot find State with given #{key}: #{query[key]}")
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
			def districts
	    	unless @@districts
					require "yaml"
	    		data = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data', 'districts.yml'))
	    		indices = INDICES.inject({}) { |memo, index| memo.merge index => [] }
	    		i = 0
	    		@@districts= data.map do |district_row|
	    			state_pcode = district_row[:state]
	    			district = new(district_row)
	    			INDICES.each do |index|
	    				indices[index] << district.send(index)
	    			end
	    			@@state_index[state_pcode] ||= []
	    			@@state_index[state_pcode] << i
	    			i += 1
		    		district
	    		end

	    		INDICES.each do |index|
	    			class_variable_set("@@#{index}_index", indices[index])
	    		end
	    	end
	    	@@districts
			end

	    ## define private methods for internal use of indexed array
	    INDICES.each do |index|
		    define_method("#{index}_index") do
		    	districts
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
class Nayyar::DistrictNotFound < StandardError; end;