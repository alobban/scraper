#!/usr/bin/env ruby
# https://www.youtube.com/watch?v=eumekfP4IKQ

require_relative 'scraper'

require 'rubygems'
require 'json'
require 'curb'
require 'nokogiri'

http = Curl.get("http://www.cardcash.com/merchants/") do |http|
	http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36"
end

# hash = {}
giftCards = {}
counter = 1

html = Nokogiri::HTML(http.body_str)
html.css("#merchants_list").each do |node|
	merchants_section = Nokogiri::HTML(node.inner_html)
	merchants_section.css(".categoryListBoxContents").each do |node|
		cards_section = Nokogiri::HTML(node.inner_html)
		cards_section.css("a").each do |node|
			url = node['href'].split('?').first
			
			# giftCards[counter] = scraper (url)
			puts "\n", counter, "\n"
			puts scraper url
			counter += 1
		end
	end
	# puts giftCards
	# puts JSON.pretty_generate(giftCards)
end