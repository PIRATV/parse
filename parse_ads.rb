#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'browser'
require_relative 'parse_ad'

class ParseAds < Browser
  def initialize
    @ads = []
    @parser = nil
  end
  def parseLinks link
    open link
    @parser = ParseAd.new
    @content = @browser.h3(class: 't_i_h3').as(class: 'second-link').each do |url|
      @parser.open url.attribute_value('href')
      @parser.go
      @ads.push @parser.getContent
    end
    @parser.close
  end

  def getAds
    @ads
  end
end
