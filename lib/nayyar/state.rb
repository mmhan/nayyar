# frozen_string_literal: true

# Represents a State in Myanmar
class Nayyar::State
  attr_reader :data

  @states = nil
  @pcode_index = []
  @iso_index = []
  @alpha3_index = []

  ATTRIBUTES = %i[
    pcode
    iso
    alpha3
    name
    my_name
  ].freeze

  INDICES = %w[pcode iso alpha3].freeze

  def initialize(data)
    @data = data
  end

  # define getters
  ATTRIBUTES.each do |attr|
    define_method attr do
      @data[attr]
    end
  end

  # allow the values to be retrieved as an array
  def [](key)
    @data[key]
  end

  def districts
    Nayyar::District.of_state self
  end

  class << self
    def all
      states
    end

    def find_by(query)
      key = get_key(query)
      (index = send("#{key}_index".to_sym).index(query[key])) && states[index]
    end

    def find_by!(query)
      if (state = find_by(query))
        state
      else
        key = get_key(query)
        raise Nayyar::StateNotFound, "Cannot find State with given #{key}: #{query[key]}"
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
      unless @states
        indices = INDICES.inject({}) { |memo, index| memo.merge index => [] }
        @states = data.map do |state_data|
          new(state_data).tap { |state| build_indices(indices, state) }
        end
        INDICES.each { |index| class_variable_set(:"@@#{index}_index", indices[index]) } # rubocop:disable Style/ClassVars
      end
      @states
    end

    def data
      YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data', 'states.yml'))
    end

    def build_indices(indices, state)
      INDICES.each { |index| indices[index] << state.send(index) }
    end

    ## define private methods for internal use of indexed array
    INDICES.each do |index|
      define_method("#{index}_index") do
        states
        class_variable_get(:"@@#{index}_index")
      end
    end

    ## return the index for query given to find_by/find_by! method
    def get_key(data)
      keys = data.keys
      if keys.length != 1 || INDICES.none? { |key| key.to_sym == keys.first.to_sym }
        raise ArgumentError, "`find_by` accepts only one of #{INDICES.join(' or ')} as argument. None provided"
      end

      keys.first
    end
  end
end

class Nayyar::StateNotFound < StandardError; end
