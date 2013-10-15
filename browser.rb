#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'watir-webdriver'
require_relative 'string'

class Browser

  def initialize
    @content = nil
    @browser = nil
    @link = nil
    @links = nil
    @client = nil
    @info = {}
  end

  def close
    @browser.close
  end

  def client timeout=180
    @client ||= Selenium::WebDriver::Remote::Http::Default.new
    @client.timeout ||= timeout # seconds – default is 60
  end

  def browser browser=:ff
    client
    @browser ||= Watir::Browser.new :ff, :http_client => @client
    @browser ||= Watir::Browser.new
  end

  def open link #for example, 'http://www.avito.ru/pyatigorsk/avtomobili_s_probegom/volkswagen_polo_2013_193630743'
    browser
    puts 'open link ' + link + '...'
    @link = link
    @browser.goto @link
  end
end