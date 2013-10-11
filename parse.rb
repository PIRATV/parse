#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'parse_ads'

ads = ParseAds.new

begin
  ads.parseLinks 'http://www.avito.ru/pyatigorsk/avtomobili_s_probegom/'
  ads.getAds.each do |ad|
    puts ad
  end
rescue Timeout::Error
  puts 'Caught a TimeOut error..'
  sleep 1
#rescue
 # parse.close
end