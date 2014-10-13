#!/usr/bin/env ruby
# https://www.youtube.com/watch?v=eumekfP4IKQ

require 'rubygems'
require 'json'
require 'curb'
require 'nokogiri'

def scraper url
	http = Curl.get(url) do |http|
		http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36"
	end

	# hash = {}
	giftCard = {}
	temp = {}

	# pull each listing under the class names
	# 'productListing-odd' and 'productListing-even'
	#
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

	def cardName (html)
		nameHeader = ""
		html.css('#productListHeading').each do |node|
			nameHeader = Nokogiri::HTML(node.inner_html)
		end
		nameHeader.text
	end

	html = Nokogiri::HTML(http.body_str)
	productName = cardName html
	# puts productName
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
			if (node['id'])
				temp[position] = parse node, odd
			end
			odd += 2
			
		end

		listing_section.css(".productListing-even").each do |node|
			position = even
			if (node['id'])
				temp[position] = parse node, even
			end
			even += 2
		end

		# Sort and format output in JSON
		#
		# puts Hash[temp.sort]
		giftCard[productName] = Hash[temp.sort]
		# puts giftCard
		# puts " \n\n Pretify \n\n"
		# puts JSON.pretty_generate(giftCard)
	end
	giftCard
end

# puts scraper ("http://www.cardcash.com/buy-discounted-gift-cards/bath-body-works/")
# puts scraper ("http://www.cardcash.com/buy-discounted-gift-cards/mgm-resorts/")
