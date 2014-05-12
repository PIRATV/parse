#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative '../browser'

class Add < Browser
  def openAddPage ad
    open 'http://spravkapira.ru/ads/add/'

    puts 'select category..'
    @browser.select(id: 'Ad_category_id').select_value 1
    @browser.select(id: 'Ad_category_id').click
    puts 'select region..'
    selectValue 'Ad_region_id', ad[:region]
    puts 'select city..'
    selectValue 'city', ad[:city]
    puts 'select mark..'
    selectValue 'Transport_mark_id', ad[:mark]
    puts 'select model..'
    selectValue 'Transport_model_id', ad[:model]
    puts 'select carcass..'
    selectValue 'Transport_carcass_id', ad[:carcass]
    puts 'select color..'
    selectValue 'Transport_color_id', ad[:color]
    puts 'select engine..'
    selectValue 'Transport_engine_id', ad[:engine]
    puts 'select engine size..'
    selectValue 'Transport_engine_size', ad[:engine_size]
    puts 'select year..'
    selectValue 'Ad_year_from', ad[:year_from]

    puts 'select box..'
    boxes = {"\u041c\u0422"=>1, "\u0410\u0422"=>2, "\u0420\u0422"=>3}
    puts boxes[ad[:box]]
    selectValue 'Transport_box_id', boxes[ad[:box]]
    puts 'select mileage from..'
    selectValue 'Transport_mileage_from', ad[:mileage_from].gsub(/\D*/, '')
    puts 'select mileage to..'
    selectValue 'Transport_mileage_to', ad[:mileage_to].gsub(/\D*/, '')

    puts 'enter name..'
    @browser.text_field(id: 'User_name').value = ad[:name]
    puts 'enter title..'
    @browser.text_field(id: 'Ad_title').value = ad[:title]
    puts 'enter phone..'
    @browser.text_field(id: 'User_phone').value = ad[:phone]
    puts 'enter payment..'
    @browser.text_field(id: 'Ad_payment_from').value = ad[:price]
    puts 'enter email..'
    @browser.text_field(id: 'User_email').value = 'piratv@inbox.ru'
    puts 'enter text..'
    @browser.text_field(id: 'Ad_text').value = ad[:text]
    puts 'upload files..'
    ad[:images].each do |image|
      %x|
        cd /var/ruby/parse/ads/images
        curl #{image} -O
      |
      @browser.file_field.value = image.gsub(/.*\/(.*?\.(?:jpe?g|png|gif))\Z/i, "/var/ruby/parse/ads/images/\\1")
      File.unlink image.gsub(/.*\/(.*?\.(?:jpe?g|png|gif))\Z/i, "/var/ruby/parse/ads/images/\\1")
    end
    puts 'done'

    @browser.form(id: 'upload-form').submit
    sleep 5
  end

  def selectValue id, value, wait = true
    if wait then
      @browser.select(id: id).wait_until_present
      @browser.select(id: id).option.wait_until_present
    end
    @browser.select(id: id).options.each do |option|
      next if option.nil? or option.text.empty? or option.value.empty? or option.text.nil? or option.value.nil?
      if option.text.numeric? or option.value.numeric? then
        if option.text == value or option.value == value then
          @browser.select(id: id).select_value option.value
          @browser.select(id: id).click
          break
        end
      else
        if option.text.downcase.include? value.downcase or option.value.downcase.include? value.downcase then
          @browser.select(id: id).select_value option.value
          @browser.select(id: id).click
          break
        end
      end
    end
  end
end