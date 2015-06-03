#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'byebug'
require 'json'

page = Nokogiri::HTML(open("2015_Guidelines_Beer.html"))

byebug

styles_hash = Hash.new
style_name = String.new


for i in 1...20
	key_path = "//*[@id=\"Section7\"]/p[#{i}]/span/text()"
	value_path = "//*[@id=\"Section7\"]/p[#{i}]/text()"

	puts key_path

	# //*[@id="Section7"]
	# //*[@id="Section7"]/h2[1]
	# //*[@id="Section7"]/a[3]/p[1]

	# //*[@id="Section7"]/a[2]/p[13]
	# //*[@id="Section7"]/a[2]/p[1]
	# //*[@id="Section7"]/p/a[3]
	# //*[@id="Section7"]/h2[1]
	# //*[@id="Section7"]/a[5]/p[14]
	#Section7 > h2.Heading_20_2_20_first
	
	key = page.xpath(key_path).to_s.downcase.tr(" ","_").tr(":", "")
	value = page.xpath(value_path).to_s.strip
# byebug

	if key == "" && value != ""
		style_name = value
		styles_hash[style_name] = Hash.new 
	elsif key.include? "vital_statistics og"
		key = key.tr("vital_statistics og", "").tr("  ", "")
		low_high_values = key.split("–")
		type = "og"
		styles_hash[style_name]["#{type}_low"] = low_high_values.first
		styles_hash[style_name]["#{type}_high"] = low_high_values.last
	elsif key.include? "fg" 
		ibu_final_gravity = key.split("fg")
		ibu_low_high = ibu_final_gravity.first.tr("  ", "").split("_–_")
		styles_hash[style_name]["ibu_low"] = ibu_low_high.first
		styles_hash[style_name]["ibu_high"] = ibu_low_high.last

		fg_low_high = ibu_final_gravity.last.tr("  ", "").split("_–_")
		styles_hash[style_name]["fg_low"] = fg_low_high.first
		styles_hash[style_name]["fg_high"] = fg_low_high.last
	elsif key.include? "abv" 
		srm_abv = key.split("abv")
		srm_low_high = srm_abv.first.tr("  ", "").split("_–_")
		styles_hash[style_name]["srm_low"] = srm_low_high.first
		styles_hash[style_name]["srm_high"] = srm_low_high.last

		abv_low_high = srm_abv.last.tr("  ", "").tr("%","").split("_–_")
		styles_hash[style_name]["abv_low"] = abv_low_high.first
		styles_hash[style_name]["abv_high"] = abv_low_high.last
	elsif key == "tags" || key == "commercial_examples"
		styles_hash[style_name][key] = value.split(", ")
	elsif key != "" && value != ""
		styles_hash[style_name][key] = value
	# else
		# break
	end
end

File.write('bjcp_html_2015.json', JSON.pretty_generate(styles_hash))
