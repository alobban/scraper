#!/usr/bin/env ruby

require 'rubygems'
require 'curb'
require 'nokogiri'

http = Curl.get("https://www.raise.com/buy-staples-gift-cards") do |http|
	http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36"
end

html = Nokogiri::HTML(http.body_str)
html.css("tbody").each do |list|
	items_html = Nokogiri::HTML(list.inner_html)
	items_html.css(".toggle-details").each do |item|
		puts item.inner_html, "\n\n"
	end
end