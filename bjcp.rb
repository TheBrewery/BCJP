#!/usr/bin/env ruby

require 'rubygems'
require 'byebug'
require 'json'

styles_hash = JSON.parse(File.read("styles.json"))

# puts styles_hash

styles_hash["styles"].each { |style|

	id, name = style["style_name"].to_s.match('(\d+\.\d+)\.\s(.*)').captures
	style["style_name"] = name
	style["identifier"] = id

	substyles = style["substyles"]

	if substyles
		substyles.each { |substyle|
		if substyle["name"].length
			id, name = substyle["name"].to_s.match('(\d+[A-Z]+)\.\s(.*)').captures
			substyle["identifier"] = id
			substyle["name"] = name
		end
		}
	end

	# puts substyle["og_low"]

	# low_high_values = substyle["og_low"].to_s.match('(\d.\d+)').names
	# puts "first #{low_high_values.first}"
	# puts "last #{low_high_values.last}"
	# type = "og"
	# styles_hash[style_name]["#{type}_low"] = low_high_values.first
	# styles_hash[style_name]["#{type}_high"] = low_high_values.last


# 	style_name = value
# 	styles_hash[style_name] = Hash.new 
# elsif key.include? "vital_statistics og"
# 	key = key.tr("vital_statistics og", "").tr("  ", "")
# 	low_high_values = key.split("–")
# 	type = "og"
# 	styles_hash[style_name]["#{type}_low"] = low_high_values.first
# 	styles_hash[style_name]["#{type}_high"] = low_high_values.last
# elsif key.include? "fg" 
# 	ibu_final_gravity = key.split("fg")
# 	ibu_low_high = ibu_final_gravity.first.tr("  ", "").split("_–_")
# 	styles_hash[style_name]["ibu_low"] = ibu_low_high.first
# 	styles_hash[style_name]["ibu_high"] = ibu_low_high.last
# 	fg_low_high = ibu_final_gravity.last.tr("  ", "").split("_–_")
# 	styles_hash[style_name]["fg_low"] = fg_low_high.first
# 	styles_hash[style_name]["fg_high"] = fg_low_high.last
# elsif key.include? "abv" 
# 	srm_abv = key.split("abv")
# 	srm_low_high = srm_abv.first.tr("  ", "").split("_–_")
# 	styles_hash[style_name]["srm_low"] = srm_low_high.first
# 	styles_hash[style_name]["srm_high"] = srm_low_high.last

# 	abv_low_high = srm_abv.last.tr("  ", "").tr("%","").split("_–_")
# 	styles_hash[style_name]["abv_low"] = abv_low_high.first
# 	styles_hash[style_name]["abv_high"] = abv_low_high.last
# elsif key == "tags" || key == "commercial_examples"
# 	styles_hash[style_name][key] = value.split(", ")
# elsif key != "" && value != ""
# 	styles_hash[style_name][key] = value
# # else
# 	# break
# end
}

File.write('bjcp_styles1.json', JSON.pretty_generate(styles_hash))
