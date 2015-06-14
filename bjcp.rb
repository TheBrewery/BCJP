#!/usr/bin/env ruby

require 'rubygems'
require 'byebug'
require 'json'

file = File.read("styles.json")
styles_hash = JSON.parse(file)

def process_substyle(array)
	unless array.nil?
		array.each { |substyle|
		if substyle["subtypes"]
			# byebug
			process_substyle(substyle["subtypes"])
		end

		if substyle["name"].length
			match = substyle["name"].to_s.match('(\d+[A-Z]+)\.\s(.*)')
			if match
				id, name = match.captures
				substyle["identifier"] = id
				substyle["name"] = name
			end
		end

		if substyle["og_low"]
			match = substyle["og_low"].to_s.match('(\d\.\d+)\s+–\s+(\d\.\d+)')
			if match
				low, high = match.captures
				substyle["og_low"] = low
				substyle["og_high"] = high
			end
		end

		if substyle["ibu_low"]
			match = substyle["ibu_low"].to_s.match('(\d+)\s+–\s+(\d+)\s+FG:\s+(\d\.\d+)\s+–\s+(\d\.\d+)')
			if match
				low, high, fg_low, fg_high = match.captures
				substyle["ibu_low"] = low
				substyle["ibu_high"] = high
				substyle["fg_low"] = fg_low
				substyle["fg_high"] = fg_high
			end
		end

		if substyle["srm_low"]
			match = substyle["srm_low"].to_s.match('(\d+\.?\d*)\s+–\s*(\d+).*ABV:\s+(\d\.\d+)\s+–\s+(\d*\.*\d+)')
			if match
				low, high, abv_low, abv_high = match.captures
				substyle["srm_low"] = low
				substyle["srm_high"] = high
				substyle["abv_low"] = abv_low
				substyle["abv_high"] = abv_high
			end
		end

		if substyle["commercial_examples"]
			substyle["commercial_examples"] = substyle["commercial_examples"].split(", ")
		end

		if substyle["tags"]
			substyle["tags"] = substyle["tags"].split(", ")
		end

		}
	end
end

styles_hash["styles"].each { |style|

	id, name = style["style_name"].to_s.match('(\d+\.\d+)\.\s(.*)').captures
	style["style_name"] = name
	style["identifier"] = id

	process_substyle(style["substyles"])
}

File.write('bjcp_styles.json', JSON.pretty_generate(styles_hash))
