#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'curb'
require 'nokogiri'

http = Curl.get("http://www.cardcash.com/bargain-bag/amazon/") do |http|
	http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36"
end

# hash = {}
giftCard = {}
temp = {}

html = Nokogiri::HTML(http.body_str)
html.css("#leftProductsListing").each do |node|
	listing_section = Nokogiri::HTML(node.inner_html)
	odd, even = 1, 2
	listing_section.css(".productListing-odd").each do |node|
		hash = {}
		hash[:position] = odd
		pid = node['id'].split('_').last
		# giftCard = pid
		hash[:quantity] = node.css('#'+pid.to_s).text
		hash[:title] = node.css('.itemTitle').text
		hash[:price] = node.css('.normalprice').text
		hash[:sale] = node.css('.productSalePrice').text
		# temp << hash
		odd += 2
		# puts temp.to_json
		# p hash
		temp[pid] = hash.to_json
		
	end
	puts giftCard = temp.to_json
	# puts JSON.pretty_generate(giftCard)
end