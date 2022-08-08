# frozen_string_literal: true

# Extract data from locations.csv which will be the source of data for the gem
# and create states.yml, districts.yml and townships.yml which will be read at runtime

require 'csv'
require 'pry'
require 'psych'

states = []
districts = []
townships = []

def state(location)
  { iso: location[:iso], pcode: location[:s_pcode], alpha3: location[:alpha3], name: location[:state],
    my_name: location[:state_in_my] }
end

def district?(location)
  !location[:d_pcode].nil?
end

def district(location)
  { pcode: location[:d_pcode], name: location[:district], my_name: location[:district_in_my],
    state: location[:s_pcode] }
end

def township?(location)
  !location[:t_pcode].nil?
end

def township(location)
  { pcode: location[:t_pcode], name: location[:township], my_name: location[:township_in_my],
    district: location[:d_pcode] }
end

CSV.foreach('locations.csv') do |location_csv_data|
  keys = %i[iso s_pcode alpha3 state state_in_my d_pcode district district_in_my t_pcode township
            township_in_my]
  location = keys.zip(*location_csv_data).to_h
  states << state(location)
  districts << district(location) if district?(location)
  townships << township(location) if township?(location)
end
states.uniq! { |state| state[:pcode] }
districts.uniq! { |district| district[:pcode] }

File.write('states.yml', states.to_yaml)
File.write('districts.yml', districts.to_yaml)
File.write('townships.yml', townships.to_yaml)
