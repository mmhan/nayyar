class Nayyar::State
	attr_reader :data

  @@states = nil
  @@pcode_index = []
  @@iso_index = []
  @@alpha3_index = []

	attributes = [
		:pcode,
		:iso,
		:alpha3,
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

	class << self
	  INDICES = %w(pcode iso alpha3)

		def all
			states
		end

	  def find_by(query)
	    key = get_key(query)
	    (index = send("#{key}_index".to_sym).index(query[key])) && states[index]
	  end

	  def find_by!(query)
	    if state = find_by(query)
	      state
	    else
	      key = get_key(query)
	      raise Nayyar::StateNotFound.new("Cannot find State with given #{key}: #{query[key]}")
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
	    def states
	    	unless @@states
	    		data = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data', 'states.yml'))
	    		@@states = data.map do |state|
	    			state = new(state)
	    			@@pcode_index << state.pcode
	          @@iso_index << state.iso
	          @@alpha3_index << state.alpha3
	    			state
	    		end
	    	end
	    	@@states
	    end

	    def pcode_index
	    	states
	    	@@pcode_index
	    end

	    def iso_index
	    	states
	    	@@iso_index
	    end

	    def alpha3_index
	    	states
	    	@@alpha3_index
	    end

		  def get_key(data)
		    keys = data.keys
		    if keys.length != 1 || %w(pcode iso alpha3).none? { |key| key.to_sym == keys.first }
		      raise ArgumentError.new("`find_by` accepts only one of pcode, iso or alpha3 as argument. None provided")
		    end
		    keys.first
		  end
	end
end
class Nayyar::StateNotFound < StandardError; end;