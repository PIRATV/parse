#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'browser'
require_relative 'parse_ad'

class ParseAds < Browser
  def initialize
    @ads = Array.new
    @parser = nil
  end
  def parseLinks link
    open link
    @browser.h3s(class: 'title').each do |link|
      @parser = ParseAd.new
      @parser.open link.a.attribute_value('href')
      @parser.go
      @ads << @parser.getContent
      @parser.close
      break
    end
  end

  def getAds
    @ads
  end
end
