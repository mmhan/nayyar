# frozen_string_literal: true

# Represents a Township in Myanmar
class Nayyar::Township
  attr_reader :data

  @townships = nil
  @district_index = {}

  ATTRIBUTES = %i[
    pcode
    name
    my_name
  ].freeze

  INDICES = %w[pcode].freeze

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
    if ATTRIBUTES.include? key
      @data[key]
    elsif key.to_sym == :district
      district
    end
  end

  def district
    Nayyar::District.find_by_pcode(@data[:district])
  end

  class << self
    def all
      townships
    end

    def of_district(district)
      state_pcode = district.pcode
      townships = self.townships
      @district_index[state_pcode].map do |index|
        townships[index]
      end
    end

    def find_by(query)
      key = get_key(query)
      (index = send("#{key}_index".to_sym).index(query[key])) && townships[index]
    end

    def find_by!(query)
      if (district = find_by(query))
        district
      else
        key = get_key(query)
        raise Nayyar::TownshipNotFound, "Cannot find State with given #{key}: #{query[key]}"
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
      unless @townships
        indices = INDICES.inject({}) { |memo, index| memo.merge index => [] }
        @townships = data.each_with_index.map do |township_row, i|
          new(township_row).tap { |township| build_indices(indices, township, township_row[:district], i) }
        end

        INDICES.each do |index|
          class_variable_set(:"@@#{index}_index", indices[index]) # rubocop:disable Style/ClassVars
        end
      end
      @townships
    end

    def data
      YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data', 'townships.yml'))
    end

    def build_indices(indices, township, district_pcode, reference_index)
      INDICES.each do |index|
        indices[index] << township.send(index)
      end
      @district_index[district_pcode] ||= []
      @district_index[district_pcode] << reference_index
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
        raise ArgumentError, "`find_by` accepts only one of #{INDICES.join(' or ')} as argument. none provided"
      end

      keys.first
    end
  end
end

class Nayyar::TownshipNotFound < StandardError; end
