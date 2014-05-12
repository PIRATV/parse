#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "unicode"
class String
  def downcase
    Unicode::downcase(self)
  end
  def downcase!
    self.replace downcase
  end

  def upcase
    Unicode::upcase(self)
  end
  def upcase!
    self.replace upcase
  end
  def capitalize
    Unicode::capitalize(self)
  end

  def capitalize!
    self.replace capitalize
  end

  def numeric?
    if self =~ /\./ then
      true if Float(self) rescue false
    else
      true if Integer(self) rescue false
    end
  end
end