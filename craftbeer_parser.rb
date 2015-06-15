#!/usr/bin/env ruby

require 'rubygems'
require 'byebug'
require 'json'
require 'nokogiri'

def parse_style (element)
	partial_page = Nokogiri::HTML(element.to_html)
	name = partial_page.xpath('//h2/a').inner_html
	family = partial_page.xpath('//h3[1]').inner_html
	description = partial_page.xpath('//p').inner_html
	params = partial_page.xpath('//ul[1]/li/span[contains(@class,\'param\')]')
	values = partial_page.xpath('//ul[1]/li/span[contains(@class,\'value\')]')
	params.each_with_index { |param, idx|
		puts "#{param.inner_html} #{values[idx].inner_html}"
	}

	puts name, family, description
end

file = File.open("craftbeer_styles.html")
page = Nokogiri::HTML(file)
styles = page.xpath('//*[@id="styles"]/div[contains(@class,\'style\')]')

styles.each { |style|
	parse_style(style)
}


