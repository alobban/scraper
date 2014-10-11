#!/usr/bin/env ruby
# https://www.youtube.com/watch?v=eumekfP4IKQ

require 'rubygems'
require 'json'
require 'curb'
require 'nokogiri'

http = Curl.get("http://www.cardcash.com/buy-discounted-gift-cards/target/") do |http|
	http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36"
end

# hash = {}
giftCard = {}
temp = {}

def parse (node, oeCount)
	hash = {}
	pid = node['id'].split('_').last
	hash[:pid] = pid
	hash[:quantity] = node.css('#'+pid.to_s).text
	hash[:title] = node.css('.itemTitle').text
	hash[:price] = node.css('.normalprice').text
	hash[:sale] = node.css('.productSalePrice').text
	return hash
end

html = Nokogiri::HTML(http.body_str)
html.css("#leftProductsListing").each do |node|
	listing_section = Nokogiri::HTML(node.inner_html)
	odd, even = 1, 2
	listing_section.css(".productListing-odd").each do |node|
		# hash = {}
		position = odd
		# pid = node['id'].split('_').last
		# hash[:pid] = pid
		# hash[:quantity] = node.css('#'+pid.to_s).text
		# hash[:title] = node.css('.itemTitle').text
		# hash[:price] = node.css('.normalprice').text
		# hash[:sale] = node.css('.productSalePrice').text
		# temp << hash
		# odd += 2
		# puts temp.to_json
		# p hash
		temp[position] = parse node, odd
		odd += 2
		
	end

	listing_section.css(".productListing-even").each do |node|
		position = even
		temp[position] = parse node, even
		even += 2
	end
	puts temp.sort
	# puts giftCard = temp.to_json
	puts " \n\n Pretify \n\n"
	puts JSON.pretty_generate(temp.sort)
end