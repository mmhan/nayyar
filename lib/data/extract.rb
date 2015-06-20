require 'csv'
require 'pry'
require 'psych'

states = []
districts = []
townships = []

CSV.foreach("locations.csv") do |iso, s_pcode, alpha3, state, d_pcode, district, t_pcode, township|
	states << {iso: iso, pcode: s_pcode, alpha3: alpha3, name: state}
	districts << {pcode: d_pcode, name: district, state: s_pcode} unless d_pcode.nil?
	townships << {pcode: t_pcode, name: township, district: d_pcode} unless t_pcode.nil?
end
states.uniq! { |state| state[:pcode] }
districts.uniq! { |districts| districts[:pcode] }

File.open("states.yml", "w") { |f| f.write states.to_yaml }
File.open("districts.yml", "w") { |f| f.write districts.to_yaml }
File.open("townships.yml", "w") { |f| f.write townships.to_yaml }