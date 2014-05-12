#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative 'browser'

class ParseAd < Browser
  def initialize
    @content = nil
    @browser = nil
    @link = nil
    @links = nil
    @client = nil
    @info = {}
  end

  def go
    @content = @browser.div :class, 'item'
    getTitle
    getImages
    getName
    getPrice
    getInfo
  end

  def getTitle
    puts 'parsing title...'
    @info[:title] = @content.h1(:class, 'h1').text + ' г.в.'
  end
  def getImages
    puts 'parsing images...'
    div = @content.div :id, 'photo'
    return unless div.img.exists?
    @info[:images] = []
    div.imgs(:class, 'thumb').each do |im|
      @info[:images].push (im.attribute_value 'src').sub('80x60', '640x480')
    end
  end
  def getPrice
    puts 'parsing price...'
    price = @content.span(:class, 'p_i_price t-item-price').span
    @info[:price] = price.text.gsub /\D*/, ''
  end
  def getName
    puts 'parsing name...'
    @info[:name] = @content.div(:id, 'seller').strong.text
  end
  def getContent
    @info
  end
  def getInfo
    info = @content.div :class, 'item-params c-1'
    puts 'parsing mark...'
    @info[:mark] = info.as[0].text
    puts 'parsing model...'
    @info[:model] = info.as[1].text
    puts 'parsing year...'
    @info[:year_from] = info.as[2].text.gsub /\D*/, ''
    puts info.divs[1].text
    #Пробег 0 - 4 999 км , 1.6 МТ , бензин , передний привод , седан , левый руль , цвет белый
    matches = info.divs[1].text.match(/Пробег\s*?(?<mileage_from>\d+\s*?\d*?)\s*?-\s*?(?<mileage_to>\d+\s*?\d+).*?\s*?(?<engine_size>\d+\.?\d+).*(?<box>[ам]т)\s*?,\s*?(?<engine>[а-яёa-z]+)\s*?,\s*?(?<privod>[а-яёa-z]+)\s*?[а-яёa-z]+\s*?,\s*?(?<carcass>[а-яёa-z]+)\s*?,\s*?(?<rudder>[а-яёa-z]+)\s*?[а-яёa-z]+\s*?,\s*?цвет\s*?(?<color>[а-яёa-z]+)/i)

    puts 'parsing info...'
    if matches && matches.names
      matches.names.each do |key|
        continue if key =~ /\A\d+\z/
        @info[key.to_sym] = matches[key]
      end
    end

    info = @content.div(:id, 'map').spans(:class, 'c-1')
    puts 'parsing region...'
    @info[:region] = info[0].text
    puts 'parsing city...'
    @info[:city] = info[1].text
    puts 'parsing text...'
    if @content.div(id: 'desc_text').exists?
      @info[:text] = @content.div(:id, 'desc_text').text.gsub /<p>(.*?)<\/p>/i, "\\1\n"
    else
      @info[:text] = "#{@info[:mark]} #{@info[:model]}, #{@info[:year_from]} г.в., пробег #{@info[:mileage_from]} - #{@info[:mileage_to]} км."
    end

    open @link.sub(/www\.avito\.ru/i, 'm.avito.ru')
    puts 'parsing phone...'
    @browser.wait_until { @browser.li(class: 'button-blue action-show-number ').exists? }
    @browser.li(class: 'button-blue action-show-number ').a.click
    @browser.wait_until { @browser.li(class: 'button-green').exists? }
    @info[:phone] = @browser.li(class: 'button-green').a.text.gsub /\D*/, ''
    puts 'done'
    @info
  end
end