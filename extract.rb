require 'csv'
require 'pry'
require 'psych'

states = []
districts = []
townships = []

CSV.foreach("locations.csv") do |s_pcode, state, d_pcode, district, t_pcode, township|
	states << {pcode: s_pcode, name: state}
	districts << {pcode: d_pcode, name: district, state: s_pcode} unless d_pcode.nil?
	townships << {pcode: t_pcode, name: township, distrct: d_pcode} unless t_pcode.nil?
end
states.uniq! { |state| state[:pcode] }
districts.uniq! { |districts| districts[:pcode] }

File.open("data/states.yml", "w") { |f| f.write states.to_yaml }
File.open("data/districts.yml", "w") { |f| f.write districts.to_yaml }
File.open("data/townships.yml", "w") { |f| f.write townships.to_yaml }