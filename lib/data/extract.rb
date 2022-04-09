# frozen_string_literal: true

# Extract data from locations.csv which will be the source of data for the gem
# and create states.yml, districts.yml and townships.yml which will be read at runtime

require 'csv'
require 'pry'
require 'psych'

states = []
districts = []
townships = []

CSV.foreach('locations.csv') do |iso, s_pcode, alpha3, state, d_pcode, district, t_pcode, township| # rubocop:disable Metrics/ParameterLists
  states << { iso: iso, pcode: s_pcode, alpha3: alpha3, name: state }
  districts << { pcode: d_pcode, name: district, state: s_pcode } unless d_pcode.nil?
  townships << { pcode: t_pcode, name: township, district: d_pcode } unless t_pcode.nil?
end
states.uniq! { |state| state[:pcode] }
districts.uniq! { |district| district[:pcode] }

File.write('states.yml', states.to_yaml)
File.write('districts.yml', districts.to_yaml)
File.write('townships.yml', townships.to_yaml)
