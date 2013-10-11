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
    @info[:title] = @content.h1(:class, 'item_title item_title-large').text + ' г.в.'
  end
  def getImages
    puts 'parsing images...'
    div = @content.div :id, 'photo'
    return unless div.img.exists?
    @info[:images] = []
    div.imgs(:class, 'thumb').each do |im|
      @info[:images].push (im.attribute_value 'src').sub(/100x75/, '640x480')
    end
  end
  def getPrice
    puts 'parsing price...'
    price = @content.span(:class, 'p_i_price t-item-price').strong
    @info[:price] = price.text.gsub /\D*/, ''
  end
  def getName
    puts 'parsing name...'
    name = @content.div(:id, 'seller').strong
    @info[:name] = name.text
  end
  def getContent
    @info
  end
  def getInfo
    info = @content.dd :class, 'item-params c-1'
    puts 'parsing mark...'
    @info[:mark_id] = info.as[0].text
    puts 'parsing model...'
    @info[:model_id] = info.as[1].text
    puts 'parsing year...'
    @info[:year_from] = info.as[2].text.gsub /\D*/, ''
    matches = info.div.text.split(/Пробег\s*(?<mileage_from>\d+(?:\s*)(?:\d+)?)\s*-?\s*(?<mileage_to>\d+(?:\s*?)\d+).*\s*(?<engine_size>\d+\.?\d+).*(?<box>[ам]т(?=,)),\s*(?<engine>[а-яёa-z]+(?=,)),\s*(?<privod>[а-яёa-z]+)\s*[а-яёa-z]+(?=,),\s*(?<cuzov>[а-яёa-z]+),\s*(?<rul>[а-яёa-z]+)\s*[а-яёa-z]+,\s*цвет\s*(?<color>[а-яёa-z]+)/i)

    puts 'parsing info...'
    matches.each do |key, value|
      continue if key =~ /\A\d+\z/
      @info[key.to_sym] = value
    end

    info = @content.div(:id, 'map').spans(:class, 'c-1')
    puts 'parsing region...'
    @info[:region] = info[0].text
    puts 'parsing city...'
    @info[:city] = info[1].text
    puts 'parsing text...'
    @info[:text] = @content.dd(:id, 'desc_text').text.gsub /<p>(.*?)<\/p>/i, "\\1\n"

    open @link.sub(/www\.avito\.ru/i, 'm.avito.ru')
    puts 'parsing phone...'
    @browser.a(id: 'showPhoneBtn').click
    sleep 3
    @info[:phone] = @browser.li(class: 'para m_item_phone').a.text.gsub /\D*/, ''
    puts 'done'
    @info
  end
end