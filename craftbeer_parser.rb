#!/usr/bin/env ruby

require 'rubygems'
require 'byebug'
require 'json'
require 'nokogiri'

def parse_stats (style_hash, element)
	params = element.xpath('//ul[1]/li/span[contains(@class,\'param\')]')
	values = element.xpath('//ul[1]/li/span[contains(@class,\'value\')]')
	params.each_with_index { |param, idx|
		param_name = param.inner_html.downcase.tr(" ", "_")
		value = values[idx].inner_html

		match = value.match('(\d+\.?\d*)%?\s-\s(\d\.?\d*)')
		if match
			low, high = match.captures
			style_hash["#{param_name}_low"] = low
			style_hash["#{param_name}_high"] = high
		else
			style_hash[param_name] = value
		end
	}
	return style_hash
end

def parse_examples (style_hash, element)
	examples = Array.new

	beer_names = element.xpath('//ul[2]/li/span[contains(@class,\'brewery\')]')
	brewery_infos = element.xpath('//ul[2]/li/span[@class=\'value\']/a')

	beer_names.each_with_index { |beer_name, idx|
		beer_hash = {
			"brewery" => brewery_infos[idx].inner_html,
			"beer" => beer_name.inner_html,
			"url" => brewery_infos[idx].xpath('@href').inner_html
		}
		examples.push(beer_hash)
	}
	style_hash["examples"] = examples
	return style_hash
end

# TODO
# def parse_style_info (style_hash, element)
# 	examples = Array.new

# 	beer_names = element.xpath('//ul[2]/li/span[contains(@class,\'brewery\')]')
# 	brewery_infos = element.xpath('//ul[2]/li/span[@class=\'value\']/a')

# 	beer_names.each_with_index { |beer_name, idx|
# 		beer_hash = {
# 			"brewery" => brewery_infos[idx].inner_html,
# 			"beer" => beer_name.inner_html,
# 			"url" => brewery_infos[idx].xpath('@href').inner_html
# 		}
# 		examples.push(beer_hash)
# 	}
# 	style_hash["examples"] = examples
# 	return style_hash
# end

def parse_style (element)
	style_hash = Hash.new
	partial_page = Nokogiri::HTML(element.to_html)

	style_hash["name"] = partial_page.xpath('//h2/a').inner_html
	style_hash["family"] = partial_page.xpath('//h3[1]').inner_html.gsub("Style Family: ", "")
	style_hash["description"] = partial_page.xpath('//p').inner_html

	# TODO
	# style_hash["image_url"] = partial_page.xpath('//img[@class=\'beer-image alignright\']/@src')
	parse_stats(style_hash, partial_page)
	parse_examples(style_hash, partial_page)
	
	puts style_hash
end

file = File.open("craftbeer_styles.html")
page = Nokogiri::HTML(file)
styles = page.xpath('//*[@id="styles"]/div[contains(@class,\'style\')]')

# parse_style(styles.first)

styles.each { |style|
	parse_style(style)
}

